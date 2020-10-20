class CreateActingJobsTable < ActiveRecord::Migration[5.2]
  def change
     # create acting_jobs table
     create_table :acting_jobs do |t|
      t.integer :person_id
      t.integer :movie_id
 
      t.timestamps
    end
  end
end
