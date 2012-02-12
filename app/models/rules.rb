class Rules < ActiveRecord::Base
  validates :board_size, :allow_nil => false, :presence => true
  has_many :divisions
end
