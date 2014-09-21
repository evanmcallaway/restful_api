Rails.application.routes.draw do
  
  resources :questions do
    resource :responses
  end
  
  root to: 'questions#index'

end
