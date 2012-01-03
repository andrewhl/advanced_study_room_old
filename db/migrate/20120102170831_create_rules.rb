class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.boolean :rengo
      t.boolean :teaching
      t.boolean :review
      t.boolean :free
      t.boolean :rated
      t.boolean :demonstration
      t.boolean :unfinished
      t.integer :tag_pos
      t.integer :tag_phrase
      t.boolean :tag_boolean
      t.boolean :ot_boolean
      t.integer :byo_yomi_periods
      t.integer :byo_yomi_seconds
      t.string :ruleset
      t.boolean :ruleset_boolean
      t.float :komi
      t.boolean :komi_boolean
      t.integer :board_size
      t.integer :handicap
      t.boolean :handicap_boolean
      t.boolean :canadian

      t.timestamps
    end
  end
end
