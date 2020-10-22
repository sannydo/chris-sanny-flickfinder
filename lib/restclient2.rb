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

  def get_person_credits(actor)
  
  end

  def get_movie_details(tmdb_id)
    Tmdb::Movie.detail(550)
  end

  def get_movie_credits(movie)

  end

  def search_people(name)
    # Store the raw results from the api 
    raw_results = Tmdb::Search.person(name)
    hash = {}
    # Strip the object of the attributes and put it into a hash
    raw_results.instance_variables.each {|var| hash[var.to_s.delete("@")] = raw_results.instance_variable_get(var) }
    hash2 = {}
    # Strip down the hash again to the object
    item = hash["table"][:results][0]
    # Map this object to another hash
    item.instance_variables.each {|var| hash2[var.to_s.delete("@")] = raw_results.instance_variable_get(var) }
    item = hash2["table"][:results]
    item.map! do |item|
      {
        name: item.instance_variable_get("@table")[:name],
        id: item.instance_variable_get("@table")[:id]
 
      }

    end
    item


  end

end
