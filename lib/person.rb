class Person < ActiveRecord::Base
  has_many :acting_jobs
  has_many :movies, through: :acting_jobs
  
end
