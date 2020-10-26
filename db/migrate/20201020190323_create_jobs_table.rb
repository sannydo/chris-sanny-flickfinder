class CreateJobsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :jobs do |t|
      t.integer :person_id
      t.integer :movie_id

      t.timestamps
    end
  end
end
