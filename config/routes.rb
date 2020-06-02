Rails.application.routes.draw do
  # get 'messages/create'
  # get 'chatrooms/show'
  # get 'chatrooms/index'
  # get 'chatrooms/update'
  # get 'food_trades/index'
  # get 'food_trades/show'
  # get 'food_trades/new'
  # get 'food_trades/create'
  # get 'food_trades/destroy'
  # get 'food_trades/update'
  # get 'user_owned_ingredients/create'
  # get 'user_owned_ingredients/destroy'
  # get 'saved_recipes/create'
  devise_for :users
  root to: 'pages#home'

# /users/sign_in	GET	devise/sessions	new
# /users/sign_up	GET	devise/registrations	new
# /users/sign_out	DELETE	devise/sessions	destroy
# /users/:id/pantry_items	POST	pantry_items	create
# /recipes/:id	GET	recipes	show
# /POST	recipes	index (search a recipe)

  get '/recipes/search', to: 'recipes#search', as: 'recipe_search'
  resources :recipes, only: [:index, :show] do
    resources :saved_recipes, only: [:create]
  end

  resources :pantry_items, only: [:index, :new, :create,:destroy]

# SAVED_RECIPES
# I can click on a saved recipe   /recipes/:id  POST  saved_recipes create
# I can see my saved recipes      /users/:id/saved_recipes  GET saved_recipes index

  resources :saved_recipes, only: [:index]

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

  resources :food_trades, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  # Get User Food Trades
  get '/my_food_trades', to: 'food_trades#user_food_trades', as: 'private_user_food_trades'

  # Routes for each food_trade category
  get 'food_trades_veggies', to: 'food_trades#veggies'
  get 'food_trades_fruits', to: 'food_trades#fruits'
  get 'food_trades_dairy', to: 'food_trades#dairy'
  get 'food_trades_meats', to: 'food_trades#meats'
  get 'food_trades_other', to: 'food_trades#other'

# CHAT
# I can chat with my neighbors            /chatrooms/:id  GET chatrooms show
# I can see my chats history              /chatrooms  GET chatrooms index
# I can send a message in a chat          /chatrooms/:id/  POST  messages  create
# I can star a chat                       /chatrooms  PATCH chatrooms update

  resources :chatrooms, only: [:show, :index, :update]
  resources :messages, only: :create

  resources :users, only: [:show, :edit, :update]
end
