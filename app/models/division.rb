class Division < ActiveRecord::Base
  belongs_to :rules
  has_many :users
  has_many :brackets
  accepts_nested_attributes_for :brackets
end
