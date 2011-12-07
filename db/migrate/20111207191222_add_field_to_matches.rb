class AddFieldToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :invalid_reason, :string
  end
end
