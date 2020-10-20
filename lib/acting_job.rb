class Acting_Job < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person
 
end