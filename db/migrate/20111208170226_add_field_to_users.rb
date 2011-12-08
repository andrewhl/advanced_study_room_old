class AddFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :division, :string
  end
end
