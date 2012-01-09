class AddMorePlayerNamesToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :black_player_name_2, :string
    add_column :matches, :white_player_name_2, :string
  end
end
