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

puts "🧑 Creating users"
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
# keywords = [{ name: "banana", number: 5 }, { name: "peach", number: 5 }, { name: "lemon", number: 5 }, { name: "tomato", number: 5 }, { name: "cake", number: 5 }, { name: "beans", number: 5 }, { name: "bacon", number: 5 }, { name: "cheese", number: 5 }, { name: "carrot", number: 5 }, { name: "eggplant", number: 5 }, { name: "pizza", number: 5 }, {name: "zucchini", number: 5}, {name: "bean sprouts"}, { name: "egg", number: 5 }, { name: "strawberry", number: 5 }, { name: "pancake", number: 5 }, { name: "burger", number: 5 }, { name: "beef", number: 5 }, { name: "chicken", number: 5 }, { name: "rice", number: 5 }, { name: "lamb", number: 5 }, { name: "coconut", number: 5 }, { name: "cherry", number: 5}, { name: "tuna", number: 5}, { name: "mango", number: 5}, { name: "pear", number: 5}, { name: "bok choy", number: 5}, { name: "pumpkin", number: 5}, { name: "bacon", number: 5}, { name: "curry", number: 5}, { name: "grape", number: 5}, { name: "donut", number: 5}, { name: "wrap", number: 5}, { name: "potato", number: 5},{ name: "juice", number: 5}, { name: "blueberry", number: 5}, { name: "crepe", number: 5}, { name: "soup", number: 5}, { name: "cucumber", number: 5}, { name: "broccoli", number: 5}, { name: "cabbage", number: 5}, { name: "brussel sprout", number: 5}, { name: "asparagus", number: 5}, { name: "lettuce", number: 5},{ name: "garlic", number: 5}, { name: "pea", number: 5}, { name: "bell pepper", number: 5}, { name: "onion", number: 5}, { name: "kale", number: 5}, { name: "leek", number: 5}, { name: "fries", number: 5}, { name: "pork", number: 5}, { name: "turkey", number: 5}, { name: "sausage", number: 5}, { name: "pineapple", number: 5}, { name: "plum", number: 5}, { name: "orange", number: 5}, { name: "watermelon", number: 5}, { name: "melon", number: 5}, { name: "kiwi", number: 5}, { name: "grapefruit", number: 5}]

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
elie_pantry_array = ["lemon zest", "lemon peel", "blanched almond flour"]
elie_pantry_array.each do |pantry_item|
  found_ingredient = Ingredient.find_by(name: pantry_item)
  # elie = User.find_by(first_name: "Elie")
  PantryItem.find_or_create_by(user: User.first, ingredient: found_ingredient)
end

stephd_pantry_array = ["cayenne pepper", "whole-weat flour", "maple syrup", "bourbon"]
stephd_pantry_array.each do |pantry_item|
  found_ingredient = Ingredient.find_by(name: pantry_item)
  PantryItem.find_or_create_by(user: User.second, ingredient: found_ingredient)
end

stephbd_pantry_array = ["salt", "garlic", "cinnamon", "extra virgin olive oil"]
stephd_pantry_array.each do |pantry_item|
  found_ingredient = Ingredient.find_by(name: pantry_item)
  PantryItem.find_or_create_by(user: User.last, ingredient: found_ingredient)
end

poyan_pantry_array = ["salt", "extra virgin olive oil", "cocoa powder", "onion"]
poyan_pantry_array.each do |pantry_item|
  found_ingredient = Ingredient.find_by(name: pantry_item)
  PantryItem.find_or_create_by(user: User.third, ingredient: found_ingredient)
end

puts "🥧 Creating saved recipes for each user..."
elie_saved_recipes = ["Apple-Cardamom Cakes with Apple Cider Icing", "Grilled Peach, Avocado, and Crab Salad with Avocado & Peach Dressing", "Avocado Salad", "Avocado Cream"]
elie_saved_recipes.each do |recipe_title|
  found_recipe = Recipe.find_by(title: recipe_title)
  SavedRecipe.find_or_create_by(user: User.first, recipe: found_recipe)
end

stephd_saved_recipes = ["Apple-Date Compote with Apple-Cider Yogurt Cheese", "Avocado Cream", "Spiced Apple Muffins with Apple Cinnamon Glaze"]
stephd_saved_recipes.each do |recipe_title|
  found_recipe = Recipe.find_by(title: recipe_title)
  SavedRecipe.find_or_create_by(user: User.second, recipe: found_recipe)
end

stephbd_saved_recipes = ["Avocado Salad", "Tomato Pie", "Blueberry Pie", "Maple Pecan Pie"]
stephbd_saved_recipes.each do |recipe_title|
  found_recipe = Recipe.find_by(title: recipe_title)
  SavedRecipe.find_or_create_by(user: User.last, recipe: found_recipe)
end

poyan_saved_recipes = ["Blueberry Pie with Lemon Sauce", "Grilled Peach, Avocado, and Crab Salad with Avocado & Peach Dressing"]
poyan_saved_recipes.each do |recipe_title|
  found_recipe = Recipe.find_by(title: recipe_title)
  SavedRecipe.find_or_create_by(user: User.last, recipe: found_recipe)
# end

puts "🍎 Creating user_owned_ingredients..."
# Elie's owned ingredients
User.first.pantry_items.each do |pantry_item|
  UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: pantry_item.ingredient)
end
UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: Ingredient.find_by(name: "lemon"))
UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: Ingredient.find_by(name: "fat-free mayonnaise"))
UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: Ingredient.find_by(name: "plum tomatoes"))
UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: Ingredient.find_by(name: "eggplant"))
UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: Ingredient.find_by(name: "green apple"))
UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: Ingredient.find_by(name: "frozen artichoke hearts"))
UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: Ingredient.find_by(name: "pork and beans"))
UserOwnedIngredient.find_or_create_by(user: User.first, ingredient: Ingredient.find_by(name: "chicken"))

# Steph D's owned ingredients
User.second.pantry_items.each do |pantry_item|
  UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: pantry_item.ingredient)
end
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "avocado"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "banana"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "white onion"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "cherry"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "nonfat milk"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "milk chocolate"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "parmigiano reggiano"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "carrots"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "ground beef"))
UserOwnedIngredient.find_or_create_by(user: User.second, ingredient: Ingredient.find_by(name: "lamb"))

# Poyan's owned ingredients
User.third.pantry_items.each do |pantry_item|
  UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: pantry_item.ingredient)
end
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "yogurt"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "zucchini"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "banana"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "cream cheese"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "full fat coconut milk"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "sun-dried tomatoes"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "ground beef"))

# Steph BD's owned ingredients
User.last.pantry_items.each do |pantry_item|
  UserOwnedIngredient.find_or_create_by(user: User.last, ingredient: pantry_item.ingredient)
end
UserOwnedIngredient.find_or_create_by(user: User.last, ingredient: Ingredient.find_by(name: "buttermilk"))
UserOwnedIngredient.find_or_create_by(user: User.last, ingredient: Ingredient.find_by(name: "low fat shredded cheddar cheese"))
UserOwnedIngredient.find_or_create_by(user: User.last, ingredient: Ingredient.find_by(name: "orange tomatoes"))
UserOwnedIngredient.find_or_create_by(user: User.last, ingredient: Ingredient.find_by(name: "heavy cream"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "yogurt"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "fresh rosemary"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "raisins"))
UserOwnedIngredient.find_or_create_by(user: User.third, ingredient: Ingredient.find_by(name: "bacon"))

puts "🥑 Creating food trades..."
# Elie's food trades
elie_owned_ingredients = [{name: "plum tomatoes", category: "Veggies"}, {name: "eggplant", category: "Veggies"}, {name: "frozen artichoke hearts", category: "Veggies"}, {name: "lemon", category: "Fruits"}, {name: "green apple", category: "Fruits"}, {name: "chicken", category: "Meats"}, {name: "fat-free mayonnaise", category: "Dairy"}, {name: "nonfat milk", category: "Dairy"}, {name: "lemon zest", category: "Other"}, {name: "lemon peel", category: "Other"}, {name: "blanched almond flour", category: "Other"}]

elie_owned_ingredients.each do |owned_ingredient|
  found_owned_ingredient = UserOwnedIngredient.find_by(ingredient_id: Ingredient.find_by(name: owned_ingredient[:name]), user: User.first)

  FoodTrade.find_or_create_by(user_owned_ingredient: found_owned_ingredient, location: User.first.address, description: "Wooow. My roommate just went bulk buying and I have too much #{owned_ingredient[:name]} left!! Still have #{rand(1..15) }. Anyone interested?", category: owned_ingredient[:category])
end

# Steph D's food trades
stephd_owned_ingredients = [{name: "white onion", category: "Veggies"}, {name: "carrots", category: "Veggies"}, {name: "avocado", category: "Fruits"}, {name: "banana", category: "Fruits"}, {name: "ground beef", category: "Meats"}, {name: "lamb", category: "Meats"}, {name: "milk chocolate", category: "Dairy"}, {name: "parmigiano reggiano", category: "Dairy"}, {name: "cayenne pepper", category: "Other"}, {name: "maple syrup", category: "Other"}, {name: "whole-weat flour", category: "Other"}]

stephd_owned_ingredients.each do |owned_ingredient|
  found_owned_ingredient = UserOwnedIngredient.find_by(ingredient_id: Ingredient.find_by(name: owned_ingredient[:name]), user: User.second)

  FoodTrade.find_or_create_by(user_owned_ingredient: found_owned_ingredient, location: User.second.address, description: "Too much #{owned_ingredient[:name]} in my house! Need to get rid of them! Got #{rand(1..10)} to share!", category: owned_ingredient[:category])
end

# Steph BD's food trades
stephbd_owned_ingredients = [{name: "orange tomatoes", category: "Veggies"}, {name: "garlic", category: "Veggies"}, {name: "raisins", category: "Fruits"}, {name: "bacon", category: "Meats"}, {name: "heavy cream", category: "Dairy"},{name: "yogurt", category: "Dairy"}, {name: "low fat shredded cheddar cheese", category: "Dairy"}, {name: "fresh rosemary", category: "Other"}, {name: "cinnamon", category: "Other"}]

stephbd_owned_ingredients.each do |owned_ingredient|
  found_owned_ingredient = UserOwnedIngredient.find_by(ingredient_id: Ingredient.find_by(name: owned_ingredient[:name]), user: User.last)

  FoodTrade.find_or_create_by(user_owned_ingredient: found_owned_ingredient, location: User.last.address, description: "Got #{rand(1..7)} #{owned_ingredient[:name]} to share if anyone is interested!", category: owned_ingredient[:category])
end

# Poyan's food trades
poyan_owned_ingredients = [{name: "zucchini", category: "Veggies"}, {name: "onion", category: "Veggies"}, {name: "sun-dried tomatoes", category: "Veggies"}, {name: "banana", category: "Fruits"}, {name: "ground beef", category: "Meats"}, {name: "yogurt", category: "Dairy"},{name: "cream cheese", category: "Dairy"}, {name: "coconut milk", category: "Other"}, {name: "extra virgin olive oil", category: "Other"}, {name: "cocoa powder", category: "Other"}]

poyan_owned_ingredients.each do |owned_ingredient|
  found_owned_ingredient = UserOwnedIngredient.find_by(ingredient_id: Ingredient.find_by(name: owned_ingredient[:name]), user: User.third)

  FoodTrade.find_or_create_by(user_owned_ingredient: found_owned_ingredient, location: User.third.address, description: "Too much #{owned_ingredient[:name]}... Willing to share! I have #{rand(1..20)} to share", category: owned_ingredient[:category])
end

puts "👋 Creating chatrooms and 💬 messages.."
# Elie
Chatroom.find_or_create_by(food_trade: User.first.food_trades.first, starred: true) # Plum tomatoes
Message.find_or_create_by(content: "Hi Elie! I would like to trade some plum tomatoes for a salad I'm planning to make this weekend!", sender_id: User.third.id, receiver_id: User.first.id, chatroom: Chatroom.first)
Message.find_or_create_by(content: "Hi Poyan! Sure thing, when are you available to meet?", sender_id: User.first.id, receiver_id: User.last.id, chatroom: Chatroom.first)

Chatroom.find_or_create_by(food_trade: User.first.food_trades.second, starred: false) # Eggplant
Message.find_or_create_by(content: "Hey Elie! Hope you're doing good. I need 2 eggplants, thanks!", sender_id: User.last.id, receiver_id: User.first.id, chatroom: Chatroom.second)

Chatroom.find_or_create_by(food_trade: User.first.food_trades.last, starred: false) # Blanched almond flour
Message.find_or_create_by(content: "Howdy!! Do you still have almond flour?", sender_id: User.second.id, receiver_id: User.first.id, chatroom: Chatroom.third)

# Steph D
Chatroom.find_or_create_by(food_trade: User.second.food_trades.first, starred: false) # White onion
Message.find_or_create_by(content: "Heyyy Stephanie! I need some white onion, is it still available?", sender_id: User.third.id, receiver_id: User.second.id, chatroom: Chatroom.find_by(food_trade: User.second.food_trades.first))
Message.find_or_create_by(content: "Hii Poyan! Yes it is!", sender_id: User.second.id, receiver_id: User.third.id, chatroom: Chatroom.find_by(food_trade: User.second.food_trades.first))

Chatroom.find_or_create_by(food_trade: User.second.food_trades.third, starred: true) # Avocado
Message.find_or_create_by(content: "Hii Steph! Need some avocadoes for my avocado toast tomorrow morning!", sender_id: User.last.id, receiver_id: User.second.id, chatroom: Chatroom.find_by(food_trade: User.second.food_trades.third))
Message.find_or_create_by(content: "OMG, avocado toasts are the best! I'm free tonight if you would like to drop by to pick them up!", sender_id: User.second.id, receiver_id: User.last.id, chatroom: Chatroom.find_by(food_trade: User.second.food_trades.third))

Chatroom.find_or_create_by(food_trade: User.second.food_trades.second, starred: true) # Garlic
Message.find_or_create_by(content: "Hey, how's is it going? Do you still have garlic?", sender_id: User.first.id, receiver_id: User.second.id, chatroom: Chatroom.find_by(food_trade: User.second.food_trades.second))
Message.find_or_create_by(content: "Hey, I'm doing good! Yes I still have garlic. When are you free for the trade?", sender_id: User.second.id, receiver_id: User.first.id, chatroom: Chatroom.find_by(food_trade: User.second.food_trades.second))

# Poyan
Chatroom.find_or_create_by(food_trade: User.third.food_trades.first, starred: true) # Zucchini
Message.find_or_create_by(content: "Hello! I need some zucchinis please!", sender_id: User.second.id, receiver_id: User.third.id, chatroom: Chatroom.find_by(food_trade: User.third.food_trades.first))

Chatroom.find_or_create_by(food_trade: User.third.food_trades.second, starred: true) # Onion
Message.find_or_create_by(content: "Hi Poyan! Do you still have onion?", sender_id: User.first.id, receiver_id: User.third.id, chatroom: Chatroom.find_by(food_trade: User.third.food_trades.second))

Chatroom.find_or_create_by(food_trade: User.third.food_trades.last, starred: true) # Cocoa powder
Message.find_or_create_by(content: "Hey! I need cocoa powder for my recipe, is it still available?", sender_id: User.last.id, receiver_id: User.third.id, chatroom: Chatroom.find_by(food_trade: User.third.food_trades.last))

# Steph BD
Chatroom.find_or_create_by(food_trade: User.last.food_trades.first, starred: true) # Orange tomatoes
Message.find_or_create_by(content: "Hi Steph! How bad are the orange tomatoes?", sender_id: User.first.id, receiver_id: User.last.id, chatroom: Chatroom.find_by(food_trade: User.last.food_trades.first))

Chatroom.find_or_create_by(food_trade: User.last.food_trades.second, starred: true) # Raisins
Message.find_or_create_by(content: "Howdyyy! I would like to trade your raisins", sender_id: User.second.id, receiver_id: User.last.id, chatroom: Chatroom.find_by(food_trade: User.last.food_trades.second))

Chatroom.find_or_create_by(food_trade: User.last.food_trades.third, starred: true) # Bacon
Message.find_or_create_by(content: "Hey! I need some bacon, thanks!", sender_id: User.third.id, receiver_id: User.last.id, chatroom: Chatroom.last)
Message.find_or_create_by(content: "Hey! Yes, when are you free to come pick it up?", sender_id: User.last.id, receiver_id: User.third.id, chatroom: Chatroom.find_by(food_trade: User.last.food_trades.third))


puts "🎉 Successfully created users, recipes, ingredients, recipe_ingredients, pantry items, saved_recipes, user_owned_ingredients, food_trades, chatrooms and messages !"
