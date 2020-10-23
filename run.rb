require_relative "./config/environment.rb"


end_case = true

TERMINAL = Prompt.new()
TERMINAL.welcome_user()


while end_case != false
  #binding.pry
  choice1 = TERMINAL.main_menu()
  if choice1 == "Go to Favorites"
    choice2 = TERMINAL.favorite_menu()
  elsif  choice1 == "Find where to Watch Favorites"
    
    TERMINAL.where_to_watch()
  elsif choice1 == "Exit"
  end_case = false
  end
end
puts TERMINAL.logout()