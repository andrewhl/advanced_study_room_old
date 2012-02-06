class AddNumberOfDivisionsToRules < ActiveRecord::Migration
  def change
    add_column :rules, :number_of_divisions, :integer
  end
end
