class AddMonthPointsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :month_points, :float
  end
end
