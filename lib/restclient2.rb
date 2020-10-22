require 'uri'
require 'net/http'
require 'openssl'
require 'json'
Tmdb::Api.key("60c89cdae03d5ddece4011df5beca5e2")
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
        item.map! do |item|
          {
            name: item.instance_variable_get("@table")[:title],
            id: item.instance_variable_get("@table")[:id]
     
          }
    
        end
        item
    
  end

  def search_platforms(name_of_movie)

  end

  def get_person_credits(tmdb_id)
    raw_results = Tmdb::Person.movie_credits(22970)
    cast = raw_results.instance_variable_get("@table")[:cast]
    cast_hash = cast.map{|item| item.instance_variable_get("@table")}
    cast_hash_limited = cast_hash.map do |item|
      item.select{|k,v| k == :title || k == :character || k == :id}
    end
    cast_hash_limited
  end

  def get_movie_details(tmdb_id)
    raw_results = Tmdb::Movie.detail(550)
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

  def get_platforms(tmdb_id)
    parameter = tmdb_id.downcase.tr(" ", "_")
    url = URI("https://rapidapi.p.rapidapi.com/idlookup?source=tmdb&country=us&source_id=movie/#{parameter}")
    results = make_telly_request(url)
    #self.class.telly_results[imdb_id.to_sym] = results
    results["collection"]["locations"].map do |item|
      {
        platform: item["display_name"]
      }
    end
  end

  def make_telly_request(url)
    

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com'
    request["x-rapidapi-key"] = '9d6d64d48dmsh56a7cd3df5b315ap180b67jsn5f6aa34f0119'

    response = http.request(request)
    return JSON.parse(response.read_body)
  end

end
