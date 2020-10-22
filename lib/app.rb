require 'pry'
# require 'rest-client'
# require 'json'
require 'tty-prompt'

class Prompt

    
    @@prompt = TTY::Prompt.new

    def welcome_user
        puts "Welcome to Flick Finder"
    end

    def ask_for_input
        value = @@prompt.select("Choose from the following choices (using the ↑/↓ arrow keys): ", %w(Actor/Actress Movies))
        return value
    end

    #after they select the value, ask user to type which movie or actress

    def name_of_movie
        puts "Please type the name of the movie: "
        title = @@prompt.ask
        a = ApiClient.new()
        a.search_movies("#{title}")
    end

    def name_of_actor
        puts "Please type the name of the actor/actress: "
        name = @@prompt.ask
        a = ApiClient.new()
        a.search_people("#{name}")
    end

    def exit
        puts "Thank you for using Flick Finder"
    end

end




