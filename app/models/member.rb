class Member < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true

  def client
    @client ||= Slack::Web::Client.new(token: auth.user.access_token)
  end

  private
  def auth
    @auth ||= SlackAuth.response(self.attrs)
  end
end
