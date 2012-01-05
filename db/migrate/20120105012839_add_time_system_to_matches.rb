class AddTimeSystemToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :time_system, :string
  end
end
