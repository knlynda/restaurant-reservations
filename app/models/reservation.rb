class Reservation < ActiveRecord::Base
  belongs_to :table

  validates :table, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :not_overbooking

  scope :overbooking, -> (table_id, start_time, end_time) {
    where('table_id = ? AND ((start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?) OR (start_time > ? AND end_time < ?))',
          table_id, start_time, start_time, end_time, end_time, start_time, end_time)
  }

  private
  def not_overbooking
    errors.add(:start_time, 'Invalid period.') unless self.class.overbooking(table_id, start_time, end_time).empty?
  end
end