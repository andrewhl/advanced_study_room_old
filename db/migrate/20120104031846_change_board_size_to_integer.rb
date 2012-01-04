class ChangeBoardSizeToInteger < ActiveRecord::Migration
  def change
    remove_column :rules, :board_size
    add_column :rules, :board_size, :integer
  end
end
