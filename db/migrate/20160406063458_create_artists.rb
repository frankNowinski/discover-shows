class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :popularity
      t.string :artist_id
      t.integer :user_id
      t.integer :jam_id

      t.timestamps null: false
    end
  end
end
