class AddFieldToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :invalid_reason, :string
    add_column :matches, :ruleset, :string
  end
end
