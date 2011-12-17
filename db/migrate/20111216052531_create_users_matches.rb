class CreateUsersMatches < ActiveRecord::Migration
  def change
    create_table :users_matches do |t|
      t.integer :user_id
      t.integer :match_id

      t.timestamps
    end
  end
end
