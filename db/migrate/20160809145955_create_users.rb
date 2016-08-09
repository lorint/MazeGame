class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :uuid
      t.string :user_agent_string

      t.timestamps
    end
  end
end
