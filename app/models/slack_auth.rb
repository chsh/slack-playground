require 'open-uri'

class SlackAuth

  class Response
    Team = Struct.new(:id, :name, keyword_init: true)
    Bot = Struct.new(:id, :access_token, :scope, keyword_init: true)
    User = Struct.new(:id, :access_token, :scope, keyword_init: true)

    def initialize(text)
      @raw = JSON.parse(text)
    end
    attr_reader :raw
    def ok?
      raw['ok'] == true
    end
    def team
      @team ||= begin
        team = raw['team']
        Team.new(id: team['id'], name: team['name'])
      end

    end
    def bot
      @bot ||= begin
        Bot.new(id: raw['bot_user_id'],
                access_token: raw['access_token'],
                scope: raw['scope'])
      end
    end
    def user
      @user ||= begin
        authed_user = raw['authed_user']
        User.new(id: authed_user['id'], access_token: authed_user['access_token'],
                 scope: authed_user['scope'])
      end
    end
  end

  def self.response(hash)
    Response.new(hash.to_json)
  end

  def authorize_url(bot_scope: true, user_scope: true)
    base_url = 'https://slack.com/oauth/v2/authorize'
    params = {}
    params.merge!(scope: bot_scopes_all.join(',')) if bot_scope
    params.merge!(user_scope: user_scopes_all.join(',')) if user_scope
    params.merge! client_id: ENV['SLACK_APP_KEY']

    base_url + '?' + params.to_query
  end

  def callback(received_params)
    base_url = 'https://slack.com/api/oauth.v2.access'
    params = { client_id: ENV['SLACK_APP_KEY'],
               client_secret: ENV['SLACK_APP_SECRET'],
               code: received_params[:code]
    }
    resp = Faraday.post(base_url, params.to_query)
    Response.new(resp.body)
  end

  # all bot scopes
  def bot_scopes_all
    %w(app_mentions:read
       calls:read calls:write
       channels:history channels:join channels:manage channels:read
       chat:write chat:write.customize chat:write.public
       commands
       dnd:read emoji:read files:read files:write
       groups:history groups:read groups:write
       im:history im:read im:write
       links:read links:write
       mpim:history mpim:read mpim:write
       pins:read pins:write
       reactions:read reactions:write
       reminders:read reminders:write
       remote_files:read remote_files:share remote_files:write
       team:read
       usergroups:read usergroups:write
       users.profile:read users:read users:read.email users:write
       workflow.steps:execute
    )
  end

  # all user scopes without identity scopes.
  def user_scopes_all
    %w(calls:read calls:write
       channels:history channels:read channels:write
       chat:write
       dnd:read dnd:write
       emoji:read
       files:read files:write
       groups:history groups:read groups:write
       im:history im:read im:write
       links:read links:write
       mpim:history mpim:read mpim:write
       pins:read pins:write
       reactions:read reactions:write
       reminders:read reminders:write
       remote_files:read remote_files:share
       search:read
       stars:read
       stars:write
       team:read
       usergroups:read usergroups:write
       users:read users:read.email users:write
       users.profile:read users.profile:write
    )
  end
end
