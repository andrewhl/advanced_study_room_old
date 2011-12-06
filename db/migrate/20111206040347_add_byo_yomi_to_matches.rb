class AddByoYomiToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :byo_yomi_periods, :integer
    add_column :matches, :byo_yomi_seconds, :integer
  end
end
