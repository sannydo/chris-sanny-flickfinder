###    F L I C K S    F I N D E R    ###
###               v2.0               ###
###    Developed by Chris Demahy     ###
#                                      #
# Helps the user find where to watch   # 
# their favorite movies and find       #
# movies by their favorite             #
# actor/actress                        #
#                                      #
# The purpose of this run file is to   #
# control the flow and state           #
# of the user based on what choicees   #
# they make.                           #
#                                      #

# Require the libraries for the environment
require_relative "./config/environment.rb"

# Case to determine when to exit the program
end_case = true

# Create a new Prompt class to control logic
TERMINAL = Prompt.new()

# Call the function to display the welcome logo
TERMINAL.welcome_user()

# If the end_case is true then the user wants to continue
while end_case == true

  # Display the main menu choices to the user. The user can
  #   choose to add favorites or find platforms to watch favorites
  main_menu_choice = TERMINAL.main_menu()
  
  # If the user chooses see their favorites
  if main_menu_choice == "Go to Favorites"
    
    # Open the favorite menu and let the user remove favorites or
    #   add a favorite to their list
    TERMINAL.favorite_menu()

  # If the user chooses to Find where to watch their favorites
  elsif  main_menu_choice == "Find where to Watch Favorites"
    
    # Calls the function that lists where to find their favorite movies
    #   and some top movies by their favorite actor/actress 
    TERMINAL.where_to_watch()

  # If the user chooses to Exit the program
  elsif main_menu_choice == "Exit"
    # Set the end case to false, causing the while loop to exit
    end_case = false
  
  end
end

# When the user exits, display a logout message
puts TERMINAL.logout()