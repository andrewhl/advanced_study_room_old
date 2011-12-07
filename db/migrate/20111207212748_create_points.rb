class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.float :amount
      t.string :source
      t.datetime :date_granted
      t.datetime :date_lost
      t.string :event
      t.string :action

      t.timestamps
    end
  end
end
