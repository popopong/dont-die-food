require 'json'
require 'uri'
require 'net/http'
require 'openssl'

# puts "🧹 Cleaning database"
# PantryItem.destroy_all
# RecipeIngredient.destroy_all
# Ingredient.destroy_all
# Recipe.destroy_all
# User.destroy_all

puts "🧑 Creating users..."
elie = User.find_or_create_by(first_name: "Elie", last_name: "Hymowitz", email: "elie@hello.com", encrypted_password: "123456")
stephd = User.find_or_create_by(first_name: "Stephanie", last_name: "Diep", email: "stephd@hello.com", encrypted_password: "123456")
poyan = User.find_or_create_by(first_name: "Poyan", last_name: "Ng", email: "poyan@hello.com", encrypted_password: "123456")
stephbd = User.find_or_create_by(first_name: "Stephanie", last_name: "BD", email: "stephbd@hello.com", encrypted_password: "123456")

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
  puts response.read_body
  recipes_array = JSON.parse(response.read_body)["results"]
  get_recipe_ingredients_and_steps(recipes_array)
end

def get_recipe_ingredients_and_steps(recipe_array)
  # Get the recipe ID
  recipe_array.each do |recipe|
    # API call #2 : Store the recipe ingredients in another variable, i.e response
    new_recipe = Recipe.new(title: recipe["title"])
    next if Recipe.find_by(title: recipe["title"])
    recipe_id = recipe["id"]
    # Make another API call to get ingredients
    url = URI("https://api.spoonacular.com/recipes/#{recipe_id}/information?apiKey=#{ENV["SPOONACULAR_APIKEY"]}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    puts response.read_body
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
    puts response.read_body
    steps = JSON.parse(response.read_body)
    if steps && steps.size > 0
      steps = steps.first["steps"]
      new_recipe.steps_data = steps 
      new_recipe.save!
    end
  end
end

# Create an array of keywords
keywords = [{ name: "avocado", number: 5 }, { name: "apple", number: 5 }, { name: "pie", number: 5 }]

keywords.each do |keyword|
  find_recipe_by_keyword(keyword)
end

puts "🍅 Creating ingredients..."
# loop through recipes and check if ingredient exists, if not create new ingredient

puts "🔗 Linking ingredients and recipes together..."
# Loops through recipes.ingredients_data
# Assign recipe.id with each ingredient.id if ingredient is present in recipe

puts "🍚 Adding pantry items to each user's pantry..."


puts "🎉 Successfully created 4 users!"