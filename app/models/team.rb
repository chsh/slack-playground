class Team < ApplicationRecord

  concerning :OmniAuthFeature do
    class_methods do
      def from_auth(auth)
        team = find_by(object_id: auth.team.id)
        attrs = { bot: {
          id: auth.bot.id,
          access_token: auth.bot.access_token,
          scope: auth.bot.scope } }
        if team
          team.update name: auth.team.name, attrs: attrs
                               else
          team = Team.create name: auth.team.name,
                             object_id: auth.team.id,
                             attrs: attrs
        end
        team
      end
    end
  end

  concerning :MemberManagement do
    included do
      has_many :members, dependent: :destroy
    end
    def member_from_auth(auth)
      member = members.find_by(object_id: auth.user.id)
      if member
        member.update attrs: auth.raw
      else
        member = members.create object_id: auth.user.id, attrs: auth.raw
      end
      member
    end
  end

  concerning :AuthManagement do
    def client
      @client ||= Slack::Web::Client.new(token: self.attrs['bot']['access_token'])
    end
  end
end
