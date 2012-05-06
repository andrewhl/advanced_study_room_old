class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_scraped, :datetime
    add_column :users, :kgs_names, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :division, :string
    add_column :users, :rank, :integer
    add_column :users, :permalink, :string
    add_column :users, :points, :float
    add_column :users, :month_points, :float
    add_column :users, :division_id, :integer
    add_column :users, :bracket_id, :integer
  end
end