class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :user_id
      t.integer :co_player_id
      t.integer :last_player_id
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
