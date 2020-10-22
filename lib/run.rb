require_relative "../config/environment.rb"

TERMINAL = Prompt.new()

TERMINAL.welcome_user()
choice1 = TERMINAL.main_menu()

binding.pry
if choice1 == "Go to Favorites"
  choice2 = TERMINAL.favorite_menu()
elsif  choice1 == "Find where to Watch Favorites"
  puts "other"
end