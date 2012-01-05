class ChangeByoYomiFieldInMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :byo_yomi_periods
    remove_column :matches, :byo_yomi_seconds
    add_column :matches, :overtime_periods, :integer
    add_column :matches, :overtime_seconds, :integer
  end
end
