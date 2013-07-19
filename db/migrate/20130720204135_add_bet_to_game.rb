class AddBetToGame < ActiveRecord::Migration
  def change
    add_column :games, :bet, :integer
  end
end
