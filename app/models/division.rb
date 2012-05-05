class Division < ActiveRecord::Base
  belongs_to :rules
  has_many :users
end
