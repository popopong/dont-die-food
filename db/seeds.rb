require 'json'
require 'uri'
require 'net/http'
require 'openssl'

# Don't take this two next lines into consideration
# Run "rake db:seed:dump FILE=db/seed_dump.rb" to save seeds in db/seed_dump.rb
# rails db:structure:dump to dump our data in a dump file

# Method to check if object is iterable - for development purposes only
def iterable?(object)
  object.respond_to? :each
end

puts "🧹 Cleaning database"
Message.destroy_all
Chatroom.destroy_all
FoodTrade.destroy_all
UserOwnedIngredient.destroy_all
SavedRecipe.destroy_all
PantryItem.destroy_all
RecipeIngredient.destroy_all
# Ingredient.destroy_all
# Recipe.destroy_all
User.destroy_all

puts "🧑 Creating users..."
elie = User.create!(first_name: "Elie", last_name: "Hymowitz", email: "elie@hello.com", password: "1234567", address: "3819 Avenue Calixa-Lavallée, Montréal, QC H2L 3A7")
stephd = User.create!(first_name: "Stephanie", last_name: "Diep", email: "stephd@hello.com", password: "1234567", address: "4141 Pierre-de Coubertin Ave, Montreal, Quebec H1V 3N7")
poyan = User.create!(first_name: "Poyan", last_name: "Ng", email: "poyan@hello.com", password: "1234567", address: "327 Avenue Melville, Westmount, Quebec H3Z 2J7")
stephbd = User.create!(first_name: "Stephanie", last_name: "BD", email: "stephbd@hello.com", password: "1234567", address: "705 Saint-Catherine St W, Montreal, Quebec H3B 4G5")

puts "👩‍🍳 Creating recipes..."
# Make three API calls to spooncular API

# API call #1 : Store the recipe ID in a variable, i.e response, add a keyword into parameters JUST RETURN THE FIRST RESULT!!
def find_recipe_by_keyword(search_term)
  url = URI("https://api.spoonacular.com/recipes/search?query=#{search_term[:name]}&number=#{search_term[:number]}&apiKey=#{ENV["SPOONACULAR_APIKEY"]}")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  response = http.request(request)
  # puts response.read_body
  recipes_array = JSON.parse(response.read_body)["results"]
  get_recipe_ingredients_and_steps(recipes_array)
end

def get_recipe_ingredients_and_steps(recipe_array)
  # Get the recipe ID
  recipe_array.each do |recipe|
    # API call #2 : Store the recipe ingredients in another variable, i.e response
    new_recipe = Recipe.new(title: recipe["title"])
    next if Recipe.find_by(title: recipe["title"]) || recipe["image"].nil?
    new_recipe.photo = "https://spoonacular.com/recipeImages/#{recipe["image"]}"
    recipe_id = recipe["id"]
    # Make another API call to get ingredients
    url = URI("https://api.spoonacular.com/recipes/#{recipe_id}/information?apiKey=#{ENV["SPOONACULAR_APIKEY"]}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    # puts response.read_body
    extended_ingredients = JSON.parse(response.read_body)
    # Stores extendedIngredient as JSON in ingredients_data column:
    if extended_ingredients && extended_ingredients.size > 0
      extended_ingredients = extended_ingredients["extendedIngredients"]
      new_recipe.ingredients_data = extended_ingredients
    end

    # API call #3 : Store the recipe steps in another variable, i.e response
    # Make another API call to get ingredients
    url = URI("https://api.spoonacular.com/recipes/#{recipe_id}/analyzedInstructions?apiKey=#{ENV["SPOONACULAR_APIKEY"]}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    # puts response.read_body
    steps = JSON.parse(response.read_body)
    if steps && steps.size > 0
      steps = steps.first["steps"]
      new_recipe.steps_data = steps
      new_recipe.save!
    end
  end
end

# Create an array of keywords
# Already in SD's master DB
keywords = [{ name: "avocado", number: 5 }, { name: "apple", number: 5 }, { name: "pie", number: 5 }]
# keywords = [{ name: "banana", number: 5 }, { name: "peach", number: 5 }, { name: "lemon", number: 5 }, { name: "tomato", number: 5 }, { name: "cake", number: 5 }, { name: "beans", number: 5 }, { name: "bacon", number: 5 }, { name: "cheese", number: 5 }, { name: "carrot", number: 5 }, { name: "eggplant", number: 5 }, { name: "pizza", number: 5 }, {name: "zucchini", number: 5}, {name: "bean sprouts"}, { name: "egg", number: 5 }, { name: "strawberry", number: 5 }, { name: "pancake", number: 5 }, { name: "burger", number: 5 }, { name: "beef", number: 5 }, { name: "chicken", number: 5 }, { name: "rice", number: 5 }, { name: "lamb", number: 5 }, { name: "coconut", number: 5 }]

# Not yet in SD's master DB

keywords.each do |keyword|
  find_recipe_by_keyword(keyword)
end

puts "🍅 Creating ingredients..."
# loop through recipes and check if ingredient exists, if not create new ingredient
recipes = Recipe.all

recipes.each do |recipe|
  recipe.ingredients_data.each do |ingredient|
    ingredient_photo = ingredient["image"]
    Ingredient.find_or_create_by(name: ingredient["name"], photo: "https://spoonacular.com/cdn/ingredients_100x100/#{ingredient_photo}")
  end
end

puts "🔗 Linking ingredients and recipes together..."
# Loops through recipes.ingredients_data
# Assign recipe.id with each ingredient.id if ingredient is present in recipe
recipes = Recipe.all

recipes.each do |recipe|
  new_recipe_ingredient = RecipeIngredient.new(recipe: recipe)
  recipe.ingredients_data.each do |ingredient|
    found_ingredient = Ingredient.find_by(name: ingredient["name"])
    new_recipe_ingredient.ingredient = found_ingredient
    new_recipe_ingredient.save!
  end
end

puts "🍚 Adding pantry items to each user's pantry..."
# Creating Elie's pantry
elie_pantry_array = ["lemon zest", "avocado", "sugar"]
elie_pantry_array.each do |pantry_item|
  found_ingredient = Ingredient.find_by(name: pantry_item)
  # elie = User.find_by(first_name: "Elie")
  PantryItem.find_or_create_by(user: elie, ingredient: found_ingredient)
end

stephd_pantry_array = ["cayenne pepper", "greek yogurt", "maple syrup", "bourbon"]
stephd_pantry_array.each do |pantry_item|
  found_ingredient = Ingredient.find_by(name: pantry_item)
  PantryItem.find_or_create_by(user: stephd, ingredient: found_ingredient)
end

stephbd_pantry_array = ["salt", "garlic", "cinnamon", "extra virgin olive oil"]
stephd_pantry_array.each do |pantry_item|
  found_ingredient = Ingredient.find_by(name: pantry_item)
  PantryItem.find_or_create_by(user: stephbd, ingredient: found_ingredient)
end

poyan_pantry_array = ["salt", "extra virgin olive oil", "garlic", "onion"]
poyan_pantry_array.each do |pantry_item|
  found_ingredient = Ingredient.find_by(name: pantry_item)
  PantryItem.find_or_create_by(user: poyan, ingredient: found_ingredient)
end

puts "🥧 Creating saved recipes for each user..."
elie_saved_recipes = ["Apple-Cardamom Cakes with Apple Cider Icing", "Grilled Peach, Avocado, and Crab Salad with Avocado & Peach Dressing", "Avocado Salad", "Avocado Cream"]
elie_saved_recipes.each do |recipe_title|
  found_recipe = Recipe.find_by(title: recipe_title)
  SavedRecipe.find_or_create_by(user: elie, recipe: found_recipe)
end

stephd_saved_recipes = ["Apple-Date Compote with Apple-Cider Yogurt Cheese", "Avocado Cream", "Spiced Apple Muffins with Apple Cinnamon Glaze"]
stephd_saved_recipes.each do |recipe_title|
  found_recipe = Recipe.find_by(title: recipe_title)
  SavedRecipe.find_or_create_by(user: stephd, recipe: found_recipe)
end

stephbd_saved_recipes = ["Avocado Salad", "Tomato Pie", "Blueberry Pie", "Maple Pecan Pie"]
stephbd_saved_recipes.each do |recipe_title|
  found_recipe = Recipe.find_by(title: recipe_title)
  SavedRecipe.find_or_create_by(user: stephbd, recipe: found_recipe)
end

poyan_saved_recipes = ["Blueberry Pie with Lemon Sauce", "Grilled Peach, Avocado, and Crab Salad with Avocado & Peach Dressing"]
poyan_saved_recipes.each do |recipe_title|
  found_recipe = Recipe.find_by(title: recipe_title)
  SavedRecipe.find_or_create_by(user: poyan, recipe: found_recipe)
end

puts "🍎 Creating user_owned_ingredients..."
elie.pantry_items.each do |pantry_item|
  UserOwnedIngredient.find_or_create_by(user: elie, ingredient: pantry_item.ingredient)
end

stephd.pantry_items.each do |pantry_item|
  UserOwnedIngredient.find_or_create_by(user: stephd, ingredient: pantry_item.ingredient)
end

stephbd.pantry_items.each do |pantry_item|
  UserOwnedIngredient.find_or_create_by(user: stephbd, ingredient: pantry_item.ingredient)
end

poyan.pantry_items.each do |pantry_item|
  UserOwnedIngredient.find_or_create_by(user: poyan, ingredient: pantry_item.ingredient)
end

puts "🥑 Creating food trades..."
# Elie's food trades
FoodTrade.find_or_create_by(user_owned_ingredient: User.first.user_owned_ingredients.first, location: "3819 Avenue Calixa-Lavallée, Montréal, QC H2L 3A7", description: "I made too much lemon zest and am ready to share with any of you! I have 2 cups of lemon zest.")

# Steph D's food trades
FoodTrade.find_or_create_by(user_owned_ingredient: stephd.user_owned_ingredients.second, location: "4141 Pierre-de Coubertin Ave, Montreal, Quebec H1V 3N7", description: "I bought way too much greek yogurt and if I eat one more spoonful I'll have nausea. Anyone wants some greek yogurt? I have 2 boxes to offer!")

# Steph BD's food trades
FoodTrade.find_or_create_by(user_owned_ingredient: stephbd.user_owned_ingredients.second, location: "705 Saint-Catherine St W, Montreal, Quebec H3B 4G5", description: "Looking for garlic for one of your recipes? I got too 5 extra garlics sitting around!")

# Poyan's food trades
FoodTrade.find_or_create_by(user_owned_ingredient: poyan.user_owned_ingredients.second, location: "327 Avenue Melville, Westmount, Quebec H3Z 2J7", description: "Too much olive oil here in my house, need to get rid of them! (1 bottle available only)")

puts "👋 Creating chatrooms..."
Chatroom.find_or_create_by(food_trade: elie.food_trades.first, starred: true)
Chatroom.find_or_create_by(food_trade: stephd.food_trades.first, starred: false)

puts "💬 Creating messages..."
Message.find_or_create_by(content: "Hi Elie! I would like to trade some lemon zest for an apple pie I'm planning to make this weekend!", sender_id: poyan.id, receiver_id: elie.id, chatroom: Chatroom.first)
Message.find_or_create_by(content: "Hi Stephanie! I need 1 box of greek yogurt, thanks!", sender_id: stephbd.id, receiver_id: stephd.id, chatroom: Chatroom.last)

puts "🎉 Successfully created users, recipes, ingredients, recipe_ingredients, pantry items, saved_recipes, user_owned_ingredients, food_trades, chatrooms and messages !"
