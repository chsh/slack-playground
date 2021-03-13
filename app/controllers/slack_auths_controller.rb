class SlackAuthsController < ApplicationController
  skip_before_action :authenticate_user!
  def new
    redirect_to SlackAuth.new.authorize_url
  end

  def callback
    result = SlackAuth.new.callback(params)
    if result.ok?
      @user = User.from_slack_oauth(result)

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Slack')
      else
        redirect_to root_path, alert: 'slack auth error'
      end
    else
      redirect_to root_path, alert: 'slack auth error'
    end
  end
end
