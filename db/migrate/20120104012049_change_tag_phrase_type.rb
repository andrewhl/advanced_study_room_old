class ChangeTagPhraseType < ActiveRecord::Migration
  
  def change
    remove_column :rules, :tag_phrase
    add_column :rules, :tag_phrase, :string
  end
  
end
