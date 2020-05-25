Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

# /users/sign_in	GET	devise/sessions	new
# /users/sign_up	GET	devise/registrations	new
# /users/sign_out	DELETE	devise/sessions	destroy
# /users/:id/pantry_items	POST	pantry_items	create
# /recipes/:id	GET	recipes	show
# /	POST	recipes	index (search a recipe)

  resources :recipes, only: [:index, :show]
  resources :users, only: [] do
    resources :pantry_items, only: [:index, :create]
  end
end
