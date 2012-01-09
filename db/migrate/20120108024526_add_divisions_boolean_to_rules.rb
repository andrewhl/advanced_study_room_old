class AddDivisionsBooleanToRules < ActiveRecord::Migration
  def change
    add_column :rules, :division_boolean, :boolean
  end
end
