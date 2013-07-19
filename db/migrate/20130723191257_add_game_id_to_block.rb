class AddGameIdToBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :game_id, :integer
  end
end
