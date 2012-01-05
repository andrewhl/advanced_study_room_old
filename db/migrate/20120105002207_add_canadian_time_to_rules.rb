class AddCanadianTimeToRules < ActiveRecord::Migration
  def change
    add_column :rules, :canadian_stones, :integer
    add_column :rules, :canadian_time, :integer
  end
end
