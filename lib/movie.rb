class Movie < ActiveRecord::Base
  has_many :people, through: :acting_jobs
  has_many :acting_jobs
end
