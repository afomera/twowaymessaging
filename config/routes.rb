Rails.application.routes.draw do
  resources :people
  devise_for :users
  root to: 'pages#home'

  resources :conversations, only: [:index] do
    resources :messages, module: :conversations, only: [:index, :create]
  end

  # Twilio Webhook for Inbound Message
  post 'conversations/messages/reply', to: 'conversations/messages#reply'

end
