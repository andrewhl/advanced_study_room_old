class AddForeignKeystoUsers < ActiveRecord::Migration
  def change
    add_column :users, :division_id, :integer
    add_column :users, :bracket_id, :integer
  end
end
