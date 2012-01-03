class AddFieldToRules < ActiveRecord::Migration
  def change
    add_column :rules, :month, :string
  end
end
