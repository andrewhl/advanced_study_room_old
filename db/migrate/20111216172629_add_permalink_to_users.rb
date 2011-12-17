class AddPermalinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :permalink, :string
  end
end
