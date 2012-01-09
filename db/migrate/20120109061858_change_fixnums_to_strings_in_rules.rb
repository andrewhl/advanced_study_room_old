class ChangeFixnumsToStringsInRules < ActiveRecord::Migration
  def change
    remove_column :rules, :board_size
    remove_column :rules, :handicap
    add_column :rules, :handicap, :string
    add_column :rules, :board_size, :string
    add_column :rules, :board_size_boolean, :boolean
  end
end
