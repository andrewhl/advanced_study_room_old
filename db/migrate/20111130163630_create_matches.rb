class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.text :result
      t.text :w_KGS_name
      t.text :b_KGS_name
      t.text :white
      t.text :black
      t.int :move_number
      t.text :komi
      t.text :handicap
      t.boolean :reviewed
      t.boolean :sgf

      t.timestamps
    end
  end
end
