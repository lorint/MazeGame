class CreatePositions < ActiveRecord::Migration[5.1]
  def change
    create_table :positions do |t|
      t.float :lat
      t.float :lng
      t.float :accuracy
      t.float :compass
      t.references :game, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
