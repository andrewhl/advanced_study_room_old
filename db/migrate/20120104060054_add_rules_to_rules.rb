class AddRulesToRules < ActiveRecord::Migration
  def change
    add_column :rules, :max_games, :integer
    add_column :rules, :points_per_win, :float
    add_column :rules, :points_per_loss, :float
    add_column :rules, :main_time, :integer
    add_column :rules, :main_time_boolean, :boolean
    remove_column :rules, :canadian
  end
end
