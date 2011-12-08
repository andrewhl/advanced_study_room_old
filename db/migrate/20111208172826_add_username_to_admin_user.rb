class AddUsernameToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :username, :string
  end
end
