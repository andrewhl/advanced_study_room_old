class AddKgsNamesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :kgs_names, :string
  end
end
