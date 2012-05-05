class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_scraped, :datetime
  end
end
