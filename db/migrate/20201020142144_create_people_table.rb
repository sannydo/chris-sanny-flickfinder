class CreatePeopleTable < ActiveRecord::Migration[5.2]
  def change
    # Create People table
    create_table :people do |t|
      t.string :name
      t.string :imdb_id
 
      t.timestamps
    end
    
  end
end
