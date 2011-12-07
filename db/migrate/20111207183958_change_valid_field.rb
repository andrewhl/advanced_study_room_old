class ChangeValidField < ActiveRecord::Migration
  def up
    rename_column(:matches, :valid, :valid_game)
  end

  def down
    remove_column(:matches, :valid_game)
  end
end
