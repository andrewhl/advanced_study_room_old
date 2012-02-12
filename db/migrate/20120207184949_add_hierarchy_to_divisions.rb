class AddHierarchyToDivisions < ActiveRecord::Migration
  def change
    add_column :divisions, :division_hierarchy, :integer
  end
end
