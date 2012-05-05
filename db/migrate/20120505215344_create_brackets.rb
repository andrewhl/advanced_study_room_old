class CreateBrackets < ActiveRecord::Migration
  def change
    create_table :brackets do |t|
      t.integer :division_id
      t.string :name
      t.string :suffix

      t.timestamps
    end
  end
end
