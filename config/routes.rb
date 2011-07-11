FacebookApp::Application.routes.draw do
  devise_for :users, controllers: {
      omniauth_callbacks: "users/omniauth_callbacks",
      sessions: 'users/sessions'
  }
  resources :users

  match 'management/deauthorize' => 'management#deauthorize', as: 'deauthorize'
  match 'management/register_auth_token' => 'management#register_auth_token', as: 'register_auth_token'

  match 'canvas' => 'canvas#index', as: 'canvas'
  match 'canvas/tab' => 'canvas#tab', as: 'tab'
end
