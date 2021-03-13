Rails.application.routes.draw do

  devise_for :users

  root to: 'root#index'

  resource :slack_auth, only: %w(new) do
    get :callback
  end
end
