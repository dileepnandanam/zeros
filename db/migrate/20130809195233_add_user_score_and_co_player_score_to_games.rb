class AddUserScoreAndCoPlayerScoreToGames < ActiveRecord::Migration
  def change
    add_column :games, :user_score, :integer
    add_column :games, :co_player_score, :integer
  end
end
