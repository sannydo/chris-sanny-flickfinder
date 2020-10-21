require 'uri'
require 'net/http'
require 'openssl'
require 'json'
require 'pry'

class ApiClient

  ### CLASS DEFINITIONS ###

  # Class Variables #
  IMDB_FILM_URL = URI("https://rapidapi.p.rapidapi.com/film/")
  IMDB_SEARCH_URL = URI("https://rapidapi.p.rapidapi.com/search/") # + "%{name_to_Search}"
  TELLY_URL = URI("https://rapidapi.p.rapidapi.com/idlookup?source=imdb&country=us&source_id=")
  
  @@results = {test: "test"}
  @@telly_results = {test: "test"}
  def self.results
    @@results
  end
  def self.telly_results
    @@telly_results
  end
  ### INSTANCE DEFINITIONS ###

  def search_movies(name)
    if @@results[name.to_sym] != nil
      current_results = @@results[name.to_sym]
    else
      current_results = self.search_imdb(name)
    end
    no_images = current_results["titles"].map do |item|
      {
        title: item["title"],
        imdb_id: item["id"]
      }
    end

    no_images
  end

  def search_people(name)
    if @@results[name.to_sym] != nil
      current_results = @@results[name.to_sym]
    else
      current_results = self.search_imdb(name)
    end
    no_images = current_results["names"].map do |item|
      {
        name: item["title"],
        imdb_id: item["id"]
      }
    end

    no_images
  end

  def search_platforms(imdb_id)
    if @@telly_results[imdb_id.to_sym] != nil
      current_results = @@telly_results[imdb_id.to_sym]
    else
      current_results = self.get_platforms(imdb_id)
    end
    current_results["collection"]["locations"].map do |item|
      {
        platform: item["display_name"]
      }
    end
  end

  def search_imdb(name)
    parameter = name.downcase.tr(" ", "_")
    url = IMDB_SEARCH_URL + URI("#{parameter}")
    puts url
    results = make_imdb_request(url)
    self.class.results[name.to_sym] = results
    results
  end
  
  def get_film(imdb_id)
    parameter = imdb_id.downcase.tr(" ", "_")
    url = IMDB_FILM_URL + URI("#{parameter}")
    puts url
    results = make_imdb_request(url)
    self.class.results[imdb_id.to_sym] = results
    results
  end

  def get_platforms(imdb_id)
    parameter = imdb_id.downcase.tr(" ", "_")
    url = URI("https://rapidapi.p.rapidapi.com/idlookup?source=imdb&country=us&source_id=#{parameter}")
    results = make_telly_request(url)
    self.class.telly_results[imdb_id.to_sym] = results
    results
  end

  private

  # Makes the actual get request to the api. Contains Headers for RapidAPI
  def make_imdb_request(url)
  
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url) 
    request["x-rapidapi-host"] = 'imdb-internet-movie-database-unofficial.p.rapidapi.com'
    request["x-rapidapi-key"] = '9d6d64d48dmsh56a7cd3df5b315ap180b67jsn5f6aa34f0119'

    response = http.request(request)
    return JSON.parse(response.read_body)

  end

  # Makes actual get request to the api. Contains Headers for RapidAPI
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

r = ApiClient.new()
#puts r.search_imdb("The Avengers")
 #puts r.get_film("tt0848228")
# puts r.get_platforms("tt0848228")
