class CreateFavoritesTable < ActiveRecord::Migration[5.2]
  def change
    # create favorites table
    create_table :favorites do |t|
      t.string :name
      t.string :imdb_id
      
      t.timestamps
    end
  end
end
