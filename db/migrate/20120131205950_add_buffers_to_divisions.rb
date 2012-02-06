class AddBuffersToDivisions < ActiveRecord::Migration
  def change
    add_column :divisions, :demotion_buffer, :integer
    add_column :divisions, :promotion_buffer, :integer
  end
end
