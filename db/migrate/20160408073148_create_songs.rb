class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :album
      t.integer :artist_id

      t.timestamps null: false
    end
  end
end
