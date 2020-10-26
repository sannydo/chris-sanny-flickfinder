require 'pry'
# require 'rest-client'
# require 'json'
require 'tty-prompt'

# The purpose of this file is to contain the main logic of the app
# Implements ApiClient from apiclient.rb
# Implements TTY, a set of gems for controlling the terminal

class Prompt
    ### GENERAL FUNCTIONS ###

    # Create a class variable storing the TTY::Prompt object
    #   So it can be reused
    @@prompt = TTY::Prompt.new

    # Create a class variable storing the Pastel object
    #   So it can be reused
    @@pastel = pastel = Pastel.new

    # Displays the welcome logo to the user
    # Returns nil
    def welcome_user
        # put some new lines just in case
        puts "\n\n\n\n\n\n\n\n\n\n\n\n"
        # Clears the terminal for the next text
        self.clear

        # Display a welcoming logo
        welcome_logo =
            "\t   ───▄▀▀▀▄▄▄▄▄▄▄▀▀▀▄───  \n" +
                "\t   ───█▒▒░░░░░░░░░▒▒█───  \n" +
                "\t   ────█░░█░░░░░█░░█────  \n" +
                "\t   ─▄▄──█░░░▀█▀░░░█──▄▄─  \n" +
                "\t   █░░█─▀▄░░░░░░░▄▀─█░░█  \n" +
                "\t   █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█ \n" +
                "\t   █░░╦─╦╔╗╦─╔╗╔╗╔╦╗╔╗░░█ \n" +
                "\t   █░░║║║╠─║─║─║║║║║╠─░░█ \n" +
                "\t   █░░╚╩╝╚╝╚╝╚╝╚╝╩─╩╚╝░░█ \n" +
                "\t   █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ \n"
        # Print the logo in blue
        puts @@pastel.blue(welcome_logo)
        # Print the credits in cyan
        puts @@pastel.cyan("\tT O   F L I X   F I N D E R")
        puts @@pastel.cyan("\t            B Y")
        puts @@pastel.cyan("\t      CHRIS AND SANNY\n\n")
    end

    # Method to display the main menu options and get feed back from the user on
    #   where they want to navigate to
    # Returns the choice of the user representing where they want to navigate to
    @@count = 0 # Class variable to track number of times the main menu function has run
    def main_menu
        # Clears the terminal and displays the mini-logo if it
        #   is not the first time calling main_menu (welcome logo not displayed)
        mini_logo = '   ＼ʕ •ᴥ•ʔ＼ FLICKS   FINDER ／ʕ •ᴥ•ʔ／'
        if @@count != 0
            self.clear
            puts @@pastel.blue(mini_logo)
        end
        # Increase the count by one for each time the menu is displayed.
        # Used to determine wheter to clear the screen and show the mini logo
        @@count += 1

        # The list of options that the user can choose from when deciding where to navigate to
        main_menu_options = [
            'Go to Favorites',
            'Find where to Watch Favorites',
            'Exit'
        ]

        # Prompt (ask) the user which option they would like to select adn returns the value they select
        @@prompt.select(
            'Hi, welcome to the main menu.' +
                ' Please select from the following list below:',
            main_menu_options
        )
    end

    def people_or_movie
        self.clear
        value =
            @@prompt.select(
                'Choose from the following choices (using the ↑/↓ arrow keys): ',
                %w[Actor/Actress Movies]
            )
    end

    # Displays the favorite menu to the user and lets them choose a selection
    def favorite_menu
        #delete, add new, go back

        # Create a new api client instance
        api = ApiClient.new

        menu_options = []
        # Adds all the people and favorite movies from the database to the menu options list
        # so the user can choose to delete them
        Person.all.each { |item| menu_options << item }
        Favorite.all.each { |item| menu_options << item }

        # turn the array of movies into an array of hashes
        # This means that when the user sees the list they see the keys of the hash (the names of the favorites)
        # But when the user makes a choice the prompt will return the value of the hash (a hash representing the item they selected)
        menu_options.map! do |item|
            { item.name => { name: item.name, id: item.imdb_id, object: item } }
        end
        menu_options << 'Exit'
        menu_options.unshift('Add to your Favorites')
        self.clear
        value =
            @@prompt.select(
                'Choose a favorite to remove it or exit to go back',
                menu_options
            )
        if value == 'Add to your Favorites'
            add_fav
        elsif value == 'Exit'
            return nil
        else
            if value[:object].class == Favorite
                Favorite.delete(value[:object].id)
            else
                job_ids = value[:object].jobs.map(&:id)
                movie_ids = value[:object].movies.map(&:id)

                Job.delete(job_ids)
                Movie.delete(movie_ids)
                Person.delete(value[:object].id)
            end
        end
    end

    def name_of_movie
        api = ApiClient.new
        puts 'Please type the name of the movie: '
        title = @@prompt.ask

        api.search_movies("#{title}")
    end

    def where_to_watch()
        puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        api = ApiClient.new
        favorite_actor_movies = []
        just_favorite_movies = []
        Movie.all.each { |item| favorite_actor_movies << item }
        Favorite.all.each { |item| just_favorite_movies << item }

        favorite_actor_movies.map! do |movie|
            { imdb_id: movie.imdb_id, name: movie.name, person: movie.people }
        end

        just_favorite_movies.map! do |movie|
            { imdb_id: movie.imdb_id, name: movie.name }
        end
        #binding.pry
        favorite_actor_movies.each do |hash|
            hash[:platforms] = api.get_platforms(hash[:imdb_id])
        end

        just_favorite_movies.each do |hash|
            hash[:platforms] = api.get_platforms(hash[:imdb_id])
        end
        puts "\nHeres Where to watch your favorite movies\n\n"

        just_favorite_movies.each do |movie|
            puts "#{movie[:name]}"
            if movie[:platforms] == nil
                puts "\tNo platform found"
                #puts "#{movie}"
            else
                movie[:platforms].each { |item| puts "\t#{item[:platform]}" }
            end
        end
        puts "\nAnd heres where you can watch some movies your favorite actors are known for\n\n"
        previous = 'placeholder'
        favorite_actor_movies.each do |movie|
            person = movie[:person][0]

            puts person.name if previous != movie[:person][0]
            puts "\t#{movie[:name]}"
            if movie[:platforms] == nil
                puts "\t\tNo Platforms found"
                previous = movie[:person][0]
            else
                movie[:platforms].each { |item| puts "\t\t #{item[:platform]}" }
                previous = movie[:person][0]
            end
        end
        @@prompt.select('', %w[Exit])
    end

    def name_of_actor
        api = ApiClient.new
        puts 'Please type the name of the actor/actress: '
        name = @@prompt.ask

        api.search_people("#{name}")
    end

    def add_fav
        api = ApiClient.new
        # Ask if they want to add a favorite actor or movie
        choice1 = people_or_movie

        if choice1 == 'Actor/Actress'
            puts 'Enter name of Actress/Actor (full name required)'
            name = STDIN.gets.chomp
            hash = api.search_people(name)
            if hash == nil
                puts 'Actor/Actress Not Found'
                @@prompt.select('', %w[Exit])
                return nil
            end
            choice2 =
                @@prompt.select(
                    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose from the list of names",
                    hash[:name]
                )
            person = Person.new
            person.name = hash[:name]
            person.imdb_id = hash[:id]
            person.save

            known_for_movies = api.get_known_for(hash[:name])
            if known_for_movies == nil
                puts 'Movies that this Actor/Actress is known for were not found'
                @@prompt.select('', %w[Exit])
                return nil
            end
            known_for_movies.each do |item|
                next if item[:title] == nil

                movie = Movie.new
                movie.name = item[:title]
                movie.imdb_id = item[:id]
                movie.save
                job = Job.new
                job.movie_id = movie.id
                job.person_id = person.id
                job.save
                # binding.pry
            end

            final_choice = person.name
            # puts Movie.all ####
        elsif choice1 == 'Movies'
            puts 'Enter name of Movie (full name required)'
            name = STDIN.gets.chomp
            list_hashes = api.search_movies(name)
            if list_hashes == nil
                puts 'Movie Not Found'
                @@prompt.select('', %w[Exit])
                return nil
            end
            hash = {}
            list_hashes.each { |movie| hash[movie[:name]] = movie[:id] }
            # By default the choice name is also the value the prompt will
            # return when selected. To provide custom values, you can provide
            # a hash with keys as choice names and their respective values:
            choice2 =
                @@prompt.enum_select(
                    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nChoose from the list of names",
                    hash
                )
            movie_hash = list_hashes.select { |item| item[:id] == choice2 }

            movie = Favorite.new
            movie.name = movie_hash[0][:name]
            movie.imdb_id = movie_hash[0][:id]
            movie.save
            final_choice = movie.name
        end
        puts "The Actor/Actress/Movie #{final_choice} was saved!"
    end

    # Presents the logout logo to the user
    def logout
        # Clears the terminal for the next text
        Gem.win_platform? ? (system 'cls') : (system 'clear')

        # Display logo
        puts '
        _______  _______  _______  ______     ______            _______ 
        (  ____ \(  ___  )(  ___  )(  __  \   (  ___ \ |\     /|(  ____ \
        | (    \/| (   ) || (   ) || (  \  )  | (   ) )( \   / )| (    \/
        | |      | |   | || |   | || |   ) |  | (__/ /  \ (_) / | (__    
        | | ____ | |   | || |   | || |   | |  |  __ (    \   /  |  __)   
        | | \_  )| |   | || |   | || |   ) |  | (  \ \    ) (   | (      
        | (___) || (___) || (___) || (__/  )  | )___) )   | |   | (____/\
        (_______)(_______)(_______)(______/   |/ \___/    \_/   (_______/
                                                                         
        '
        # Friendly goodbye message
        puts 'Thank you for using Flick Finder!'
    end

    #### UTILITY FUNCTIONS ####
    # Functions that help the rest of the program run

    # Clears the terminal
    def clear
        Gem.win_platform? ? (system 'cls') : (system 'clear')
    end
end
