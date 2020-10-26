require 'uri'
require 'net/http'
require 'openssl'
require 'json'

# Api Client v2 that was developed to interface with The Movie Database api
# as well as the Utelly API through the RapidApi Platform

# Special thanks to https://github.com/18Months/themoviedb-api
# This wraper of tMDB api made our development much faster by not having
# to write out request URLs and Headders

class ApiClient
    Tmdb::Api.key(ENV['TMDB_API_KEY'])
    ### CHRIS KEY 60c89cdae03d5ddece4011df5beca5e2

    # Searches the TMDB api for movie titles
    # Takes a string of the exact name of the movie the user wants to find
    # Returns a list of movies similiar to the search and their corresponding tmdb_id
    #   Note: User generally has to put in the exact spelling of the person and this can
    #     return duplicate listings that look similiar. In general choose the item higher in
    #     the list to get more accurate results
    def search_movies(name)
        # The TMDB api wrapper returns an instance of a 'results' object
        # This object (OpenStruct?) contains the meta data of the request made to the api
        # in a instance variable called table, which also contains a list of TMDB::Movie
        # Objects that represent the movies the api returned as results of the search

        # Store the raw results object from the api
        results_object = Tmdb::Search.movie(name)

        # Check if the part of the 'results' object that contains the actual list of movies
        # is empty and if it is return nil (Meaning movie was not found) and exit the function
        if results_object.instance_variable_get('@table')[:results][0] == nil
            return nil
        end

        # Strip the results object of the attributes and store them in the results hash
        results_hash = results_object.instance_variable_get('@table')
        # Get the list of movies and store them in an array
        movie_array = results_hash[:results]
        # map over the array to substitute a hash for each movie object containing only their
        #   name and id (also stored under @table instance variable on the object)
        movie_array.map do |movie|
            {
                name: movie.instance_variable_get('@table')[:title],
                id: movie.instance_variable_get('@table')[:id]
            }
        end
        # returns the array
    end

    # Gets a few of the movies the actor is known for according to The Movie Database
    # rather than getting all the movies the actors acted in (most of the time was way too many and overloaded the apis)
    # Takes the string of the name of the actor/actress as an argument
    # Returns an array of hashes representing some famous movies they have acted in
    def get_known_for(name)
        # The TMDB api wrapper returns an instance of a 'results' object
        # This object (OpenStruct?) contains the meta data of the request made to the api
        # in a instance variable called table, which also contains a list of TMDB::People
        # Objects that represent the people the api returned as results of the search

        # store the raw results from the api
        results_object = Tmdb::Search.person(name)

        # Check if the part of the 'results' object that contains the actual list of people
        # is empty and if it is return nil (Meaning the person was not found) and exit the function

        if results_object.instance_variable_get('@table')[:results][0] == nil
            return nil
        end

        # Strip the results object of the attributes and store them in the results hash
        results_hash = results_object.instance_variable_get('@table')

        # Assume that the program wants the first actor matching the search from the list of results
        person_object = results_hash[:results][0]

        # Get the array of movies that the actor is known for, stored under the table
        # instance variable of the object
        movie_list = person_object.instance_variable_get('@table')[:known_for]

        # Map over the array and for each of the objects substitute a hash containing just the movie title and id
        movie_list.map do |movie_object|
            {
                title: movie_object.instance_variable_get('@table')[:title],
                id: movie_object.instance_variable_get('@table')[:id]
            }
        end
        # returns the array
    end

    # Searches the TMDB api for actors and actresses
    # Takes the name of the actor/actress as an argument
    # Returns a hash of their name and id
    def search_people(name)
        # The TMDB api wrapper returns an instance of a 'results' object
        # This object (OpenStruct?) contains the meta data of the request made to the api
        # in a instance variable called table, which also contains a list of TMDB::Movie
        # Objects that represent the people the api returned as results of the search

        # Store the raw results from the api
        results_object = Tmdb::Search.person(name)

        # Check if the part of the 'results' object that contains the actual list of people
        # is empty and if it is return nil (Meaning the person was not found) and exit the function
        if results_object.instance_variable_get('@table')[:results][0] == nil
            return nil
        end

        # Strip the results object of the attributes and store them in the results hash
        results_hash = results_object.instance_variable_get('@table')

        # Assume that the program wants the first actor matching the search from the list of results
        person_object = results_hash[:results][0]

        # Returns a hash with the persons name and id (stored under table instance variable)
        {
            name: person_object.instance_variable_get('@table')[:name],
            id: person_object.instance_variable_get('@table')[:id]
        }
    end

    # Fetches the platforms available to watch the given movie on
    # Takes the tmdb id for the movie you want to watch
    # Returns an array of hashes that represent each platform you can watch that movie
    def get_platforms(tmdb_id)
        # Converts the given tmdb_id into a URI friendly parameter
        parameter = tmdb_id.downcase.tr(' ', '_')

        # Build the request URL using the parameter
        url =
            URI(
                "https://rapidapi.p.rapidapi.com/idlookup?source=tmdb&country=us&source_id=movie/#{
                    parameter
                }"
            )

        # Use utility function to make the api call with propper headers and settings
        results = make_telly_request(url)

        # Return nil if the results are empty
        return nil if results['collection']['locations'] == nil
        # Store the platforms in an array
        results_array = results['collection']['locations']
        # prints a loading bar to indicate an api call (no new line)
        print '###'
        # return an array of hashes with just the platform display name
        results_array.map { |item| { platform: item['display_name'] } }
    end

    # Utility function to make the UTelly api request with propper settings and headers
    # Takes a uri object as the url you want to requst
    # Uses the utelly api on rapidapi https://rapidapi.com/utelly/api/utelly
    def make_telly_request(url)
        # Uses Unirest to make the request

        # Create a new http object with the settings from the url(uri) object
        http = Net::HTTP.new(url.host, url.port)

        # use ssl for the request
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        # Create a new request with the uri object
        request = Net::HTTP::Get.new(url)

        # set the right headers for RapidAPI
        # Rapid API key from environment variable
        request['x-rapidapi-host'] =
            'utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com'
        request['x-rapidapi-key'] = ENV['UTELLY_API_KEY']
        # '9d6d64d48dmsh56a7cd3df5b315ap180b67jsn5f6aa34f0119'

        # Make the actual request using the http object
        response = http.request(request)

        # Parse the json response into a hash and return it
        return JSON.parse(response.read_body)
    end
end
