class AddRanksToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :black_player_rank_2, :integer
    add_column :matches, :white_player_rank_2, :integer
  end
end
