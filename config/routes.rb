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
    resources :saved_recipes, only: [:index]
  end

# SAVED_RECIPES
# I can click on a saved recipe   /recipes/:id  POST  saved_recipes create
# I can see my saved recipes      /users/:id/saved_recipes  GET saved_recipes index

  resources :saved_recipes, only: [:create]

# USER_OWNED INGREDIENTS
# I can check an ingredient on the ingredients list on the recipe show page    /recipes/:id  POST  user_owned_ingredients  Create
# I can uncheck an ingredient on the ingredients list on the recipe show page  /recipes/:id  DELETE  user_owned_ingredients  destroy

  resources :user_owned_ingredients, only: [:create, :destroy]

# FOOD TRADES
# I can see all of my trades              /users/:id/food_trades  GET food_trades index
# I can see the details of a food trade   /users/:id/food_trades/:food_trade_id GET food_trades show
# I can share that I have food to trade   /users/:id/food_trades/new  GET / POST  food_trades new + create
# I can delete a food trade               /users/:id/food_trades  DELETE  food_trades destroy
# I can update a food trade               /users/:id/food_trades/:food_trade_id PATCH food_trades update

  resources :food_trades, only: [:index, :show, :new, :create, :update, :destroy]

# CHAT
# I can chat with my neighbors            /chatrooms/:id  GET chatrooms show
# I can see my chats history              /chatrooms  GET chatrooms index
# I can send a message in a chat          /chatrooms/:id/  POST  messages  create
# I can star a chat                       /chatrooms  PATCH chatrooms update

  resources :chatrooms, only: [:show, :index, :update] do
    resources :messages, only: :create
  end

end
