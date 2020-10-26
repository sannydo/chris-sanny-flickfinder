class CreateMoviesTable < ActiveRecord::Migration[5.2]
  def change
    # Creater Movies table
    create_table :movies do |t|
      t.string :name
      t.string :imdb_id

      t.timestamps
    end
  end
end
