class AddMoreFieldsToRules < ActiveRecord::Migration
  def change
    add_column :rules, :time_system, :string
  end
end
