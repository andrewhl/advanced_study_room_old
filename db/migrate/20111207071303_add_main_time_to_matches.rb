class AddMainTimeToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :main_time, :integer
  end
end
