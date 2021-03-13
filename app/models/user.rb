class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  concerning :SlackAuthFeature do
    class_methods do
      def from_slack_oauth(auth)
        transaction do
          team = Team.from_auth(auth)
          member = team.member_from_auth(auth)
          unless member.user
            member.update user: User.create(
              email: UniqueToken.generate + '@example.com',
              password: Devise.friendly_token[0, 20]
            )
          end
          member.user
        end
      end
    end
    def auth_response
      @auth_response ||= SlackAuth.response(self.raw)
    end
  end

  concerning :MemberFeature do
    included do
      has_one :member, dependent: :nullify
      delegate :client, to: :member
    end
  end
end
