require 'pry'
# require 'rest-client'
# require 'json'
require 'tty-prompt'

class Prompt

    
    @@prompt = TTY::Prompt.new
    

    def welcome_user
        puts "Welcome to Flick Finder"
    end

    def main_menu
        main_menu_options =["Go to Favorites", "Find where to Watch Favorites"]
        @@prompt.select("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nHi, welcome to the main menu. Please select from the following list below:", main_menu_options)
    end

    def people_or_movie
        value = @@prompt.select("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose from the following choices (using the ↑/↓ arrow keys): ", %w(Actor/Actress Movies))
        return value
    end

    def favorite_menu
        #delete, add new, go back
        api = ApiClient2.new()
        temp_array = []
        Person.all.each{|item| temp_array << item}
        Movie.all.each{|item| temp_array << item}
        temp_array.map! do |item|
            {
                name: item.name,
                id: item.imdb_id
            }
        end
        temp_array << "Exit"
        temp_array.unshift("Add to your Favorites")
        #binding.pry
        value = @@prompt.select("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose a favorite to remove it or exit to go back", temp_array)
        if value == "Add to your Favorites"
            self.add_fav()
        end
       
    end

    def name_of_movie
        api = ApiClient2.new()
        puts "Please type the name of the movie: "
        title = @@prompt.ask
        
        api.search_movies("#{title}")
    end

    

    def name_of_actor
        api = ApiClient2.new()
        puts "Please type the name of the actor/actress: "
        name = @@prompt.ask
        
        api.search_people("#{name}")
    end

    def add_fav
        api = ApiClient2.new()
        choice1 = people_or_movie()
        if choice1 == "Actor/Actress"
            puts "Enter name of Actress/Actor (full name preferred)"
            name = STDIN.gets.chomp()
            hash = api.search_people(name)
            choice2 = @@prompt.select("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose from the list of names", hash[:name] )
            puts choice2 #=> "Brad Pitt"
            Person.create(name: hash[:name], imdbd_id: hash[:id])
            Person.find(hash[:id])

        elsif choice1 == "Movies"
        
        end
    end

    def exit
        puts "Thank you for using Flick Finder!"
    end

end
