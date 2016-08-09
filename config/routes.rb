Rails.application.routes.draw do
  get 'users/new', as: :new_user
  post 'users/create' => "users#create", as: :users
  resources :games do
	  resources :positions, only: [:create]
	end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
