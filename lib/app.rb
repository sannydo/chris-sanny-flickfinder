require 'pry'
# require 'rest-client'
# require 'json'
require 'tty-prompt'

class Prompt


    def welcome_user
        puts "Welcome to Flick Finder"
    end

    def ask_for_input

        prompt = TTY::Prompt.new
        value = prompt.select("Choose from the following choices (using the ↑/↓ arrow keys): ", %w(Actor/Actress Movies))
        return value
    end

    #after they select the value, ask user to type which movie or actress

    def input
        puts "Please type the title of the movie or the actor/actress's name:
        answer = gets.chomp
    end

    def exit
        puts "Thank you for using Flick Finder"
    end

end




