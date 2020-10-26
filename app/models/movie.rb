class Movie < ActiveRecord::Base
  has_many :jobs
  has_many :people, through: :jobs
end
