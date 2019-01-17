Rails.application.routes.draw do
  namespace :v1 do

    post 'auth/login', to: 'authentication#authenticate'
    post 'signup', to: 'users#create'
    resources :users do
      get 'profile', on: :collection
    end

    resources :projects do
      resources :tasks do
        get :make_completed, on: :member
        get :make_not_completed, on: :member
      end
    end
  end
end
