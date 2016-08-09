class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.float :lat1
      t.float :lng1
      t.float :lat2
      t.float :lng2
      t.integer :columns
      t.integer :rows
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
