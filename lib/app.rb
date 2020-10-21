require 'pry'
# require 'rest-client'
# require 'json'
require 'tty-prompt'

prompt = TTY::Prompt.new


def welcome_user
    puts "Welcome to Flick Finder"
end

def ask_for_input
prompt.select("Choose from the following choices (using the ↑/↓ arrow keys): ", %w(Actor/Actress Movies))
# =>
# Choose your destiny? (Use ↑/↓ arrow keys, press Enter to select)
# ‣ Scorpion
#   Kano
#   Jax
end





# def print_titles(movies)
#     movies.each_with_index do |movie, index|
#         puts "#{index+1}: #{movie["Movie"]["title"]}"
# end

# def run
#     welcome_user
#     search_term = ask_for_input
#     movies = look_for_movies(search_term)
#     print_titles(movies)
# end

def exit
    puts "Thank you for using Flick Finder"
end

# def back
#     #return to main menu
# end