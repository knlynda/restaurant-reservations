class Table < ActiveRecord::Base
  has_many :reservations

  validates :number, presence: true, numericality: true, uniqueness: true
end