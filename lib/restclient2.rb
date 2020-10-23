require 'uri'
require 'net/http'
require 'openssl'
require 'json'
Tmdb::Api.key("60c89cdae03d5ddece4011df5beca5e2")


### CHRIS KEY 60c89cdae03d5ddece4011df5beca5e2
class ApiClient2

  def search_movies(name)
        # Store the raw results from the api 
        raw_results = Tmdb::Search.movie(name)
        hash = {}
        # Strip the object of the attributes and put it into a hash
        raw_results.instance_variables.each {|var| hash[var.to_s.delete("@")] = raw_results.instance_variable_get(var) }
        hash2 = {}
        # Strip down the hash again to the object
        item = hash["table"][:results][0]
        # Map this object to another hash
        item.instance_variables.each {|var| hash2[var.to_s.delete("@")] = raw_results.instance_variable_get(var) }
        item = hash2["table"][:results]
        pp item.instance_variable_get("@table")
        item.map do |item|
          {
            name: item.instance_variable_get("@table")[:title],
            id: item.instance_variable_get("@table")[:id]
     
          }
    
        end
  end

  

  
  def get_person_credits(tmdb_id)
    raw_results = Tmdb::Person.movie_credits(tmdb_id)
    cast = raw_results.instance_variable_get("@table")[:cast]
    cast_hash = cast.map{|item| item.instance_variable_get("@table")}
    cast_hash_limited = cast_hash.map do |item|
      item.select{|k,v| k == :title || k == :character || k == :id}
    end
    cast_hash_limited
  end

  def get_movie_details(tmdb_id)
    raw_results = Tmdb::Movie.detail(tmdb_id)
    hash = {}
    raw_results.instance_variables.each { |var| hash[var.to_s.delete("@")] = raw_results.instance_variable_get(var)}
    hash
    end

  def get_movie_credits(tmdb_id)
    raw_results = Tmdb::Movie.cast(tmdb_id)
    
    raw_results.map! do |item|
      item.instance_variable_get("@table")
    end
    
    results = raw_results.map do |item|
      item.select{ |k,v| k == :id || k == :name}
    end
    results
  end

  def get_known_for(name)
    raw_results = Tmdb::Search.person(name)
    hash = {}
    # Strip the object of the attributes and put it into a hash
    raw_results.instance_variables.each {|var| hash[var.to_s.delete("@")] = raw_results.instance_variable_get(var) }
    hash2 = {}
    # Strip down the hash again to the object
    object = hash["table"][:results][0]
    #binding.pry
    movie_list = object.instance_variable_get("@table")[:known_for]
    movie_list.map do |movie_object|
      {
        title: movie_object.instance_variable_get("@table")[:title],
        id: movie_object.instance_variable_get("@table")[:id]
      }
        end
    
  end
  
  def search_people(name)
    # Store the raw results from the api 
    raw_results = Tmdb::Search.person(name)
    hash = {}
    # Strip the object of the attributes and put it into a hash
    raw_results.instance_variables.each {|var| hash[var.to_s.delete("@")] = raw_results.instance_variable_get(var) }
    hash2 = {}
    # Strip down the hash again to the object
    object = hash["table"][:results][0]
      {
        name: object.instance_variable_get("@table")[:name],
        id: object.instance_variable_get("@table")[:id]
 
      }
  end

  def search_platforms(name_of_movie)
    puts "Getting #{name_of_movie} from Utelly!"
    parameter = name_of_movie
    # url = URI("https://rapidapi.p.rapidapi.com/idlookup?source=tmdb&country=us&source_id=movie/#{parameter}")
    url = URI("https://rapidapi.p.rapidapi.com/lookup?term=#{parameter}&country=uk")
    results = make_telly_request(url)
    #self.class.telly_results[imdb_id.to_sym] = results
    #binding.pry
    if results["collection"]["locations"] == nil
      return nil
    else
      stuff = results["collection"]["locations"].map do |item|
        {
          platform: item["display_name"]
        }
        
      end
    end
    binding.pry
    puts "results: #{stuff}"
    stuff
  end

  def get_platforms(tmdb_id)
    #puts "Getting #{tmdb_id} from Utelly!"
    print '#'
    parameter = tmdb_id.downcase.tr(" ", "_")
    url = URI("https://rapidapi.p.rapidapi.com/idlookup?source=tmdb&country=us&source_id=movie/#{parameter}")
    results = make_telly_request(url)
    #self.class.telly_results[imdb_id.to_sym] = results
    #binding.pry
    if results["collection"]["locations"] == nil
      return nil
    else
      propper_results = results["collection"]["locations"].map do |item|
        {
          platform: item["display_name"]
        }
        
      end
    end
    #puts "results: #{propper_results}"
    propper_results
  end

  def make_telly_request(url)
    

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = '9d6d64d48dmsh56a7cd3df5b315ap180b67jsn5f6aa34f0119'
    ### SANNY KEY 876a9d03aamsh83390dd5c6d0f21p1a6f93jsn007c7c139bbc
    ### CHRIS KEY 9d6d64d48dmsh56a7cd3df5b315ap180b67jsn5f6aa34f0119
    response = http.request(request)
    return JSON.parse(response.read_body)
  end

end
