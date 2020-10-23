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
        main_menu_options =["Go to Favorites", "Find where to Watch Favorites", "Exit"]
        @@prompt.select("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nHi, welcome to the main menu. Please select from the following list below:", main_menu_options)
    end

    def people_or_movie
        value = @@prompt.select("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose from the following choices (using the ↑/↓ arrow keys): ", %w(Actor/Actress Movies))
        return value
    end

    def favorite_menu
        #delete, add new, go back
        # TODO Add remove functionality
        api = ApiClient2.new()
        temp_array = []
        Person.all.each{|item| temp_array << item}
        Favorite.all.each{|item| temp_array << item}
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
            add_fav()
        end
       
    end

    def name_of_movie
        api = ApiClient2.new()
        puts "Please type the name of the movie: "
        title = @@prompt.ask
        
        api.search_movies("#{title}")
    end

    
    def where_to_watch()
        api = ApiClient2.new()
        favorite_actor_movies = []
        just_favorite_movies = []
        Movie.all.each{ |item| favorite_actor_movies << item}
        Favorite.all.each{|item| just_favorite_movies << item}

        favorite_actor_movies.map! do |movie|
            
            {
                imdb_id: movie.imdb_id(),
                name: movie.name,
                person: movie.people
            }    
        end
      
        just_favorite_movies.map! do |movie|
          {
              imdb_id: movie.imdb_id(),
              name: movie.name()
          }
        end
        #binding.pry
        favorite_actor_movies.each do |hash|
          hash[:platforms] = api.get_platforms(hash[:imdb_id])
        end
        

        just_favorite_movies.each do |hash|
            hash[:platforms] = api.get_platforms(hash[:imdb_id])
        end
        puts "Heres Where to watch your favorite movies"
        
        just_favorite_movies.each do |movie|
            puts "#{movie[:name]}"
            movie[:platforms].each do |item|
                puts item[:platform]
            end
        end
        puts "And heres where you can watch some movies your favorite actors are known for"
        previous = "placeholder"
        favorite_actor_movies.each do |movie|
            person = movie[:person][0]
            puts person.name() if previous == movie[:person][0]
            puts "#{movie[:name]}"
            movie[:platforms].each do |item|
                puts "\t #{item[:platform]}"
            end
            previous = movie[:person][0]
        end
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
            # puts "Enter name of Actress/Actor (full name preferred)"
            name = STDIN.gets.chomp()
            hash = api.search_people(name)
            choice2 = @@prompt.select("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose from the list of names", hash[:name] )
            person = Person.new()
            person.name = hash[:name]
            person.imdb_id = hash[:id]
            person.save()
            api.get_known_for(hash[:name]).each do |item| #=> [ {title: "fightclub", id: 1233424 }, {} ]
                movie = Movie.new()
                movie.name = item[:title]
                movie.imdb_id = item[:id]
                movie.save
                job = Job.new()
                job.movie_id = movie.id()
                job.person_id = person.id()
                job.save
                # binding.pry
            end
            
            final_choice = person.name
            # puts Movie.all
        elsif choice1 == "Movies"
                puts "Enter name of Movie (full name preferred)"
                name = STDIN.gets.chomp()
                list_hashes = api.search_movies(name)
                hash = {}
                list_hashes.each do |movie|
                    hash[movie[:name]] = movie[:id]
                end
                # By default the choice name is also the value the prompt will 
                # return when selected. To provide custom values, you can provide 
                # a hash with keys as choice names and their respective values:
                choice2 = @@prompt.enum_select("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose from the list of names", hash )
                movie_hash = list_hashes.select do |item|
                    item[:id] == choice2
                end

                movie = Favorite.new()
                movie.name = movie_hash[0][:name]
                movie.imdb_id = movie_hash[0][:id]   
                movie.save()
                final_choice = movie.name
        end
        puts "The Actor/Actress/Movie #{final_choice} was saved!"
    end

    def logout
        puts "Thank you for using Flick Finder!"
    end

end
