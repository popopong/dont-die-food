puts "🧹 Cleaning database"
Pantry_items.destroy_all
Recipe_ingredients.destroy_all
Ingredient.destroy_all
Recipe.destroy_all
User.destroy_all

puts "🧑 Creating users..."
elie = User.create!(first_name: "Elie", last_name: "Hymowitz", email: "elie@hello.com", encrypted_password: "123456")
stephd = User.create!(first_name: "Stephanie", last_name: "Diep", email: "stephd@hello.com", encrypted_password: "123456")
poyan = User.create!(first_name: "Poyan", last_name: "Ng", email: "poyan@hello.com", encrypted_password: "123456")
stephbd = User.create!(first_name: "Stephanie", last_name: "BD", email: "stephbd@hello.com", encrypted_password: "123456")

puts "👩‍🍳 Creating recipes..."

puts "🍅 Creating ingredients..."

puts "🔗 Linking ingredients and recipes together..."

puts "🍚 Adding pantry items to each user's pantry..."

puts "🎉 Successfully created 4 users!"