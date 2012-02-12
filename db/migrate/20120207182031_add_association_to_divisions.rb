class AddAssociationToDivisions < ActiveRecord::Migration
  def change
    add_column :divisions, :rules_id, :integer
  end
end
