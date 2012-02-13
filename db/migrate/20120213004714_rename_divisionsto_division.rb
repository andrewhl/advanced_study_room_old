class RenameDivisionstoDivision < ActiveRecord::Migration
  def change
    rename_table :divisions, :division
  end
end
