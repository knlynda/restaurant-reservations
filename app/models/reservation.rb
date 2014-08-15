class Reservation < ActiveRecord::Base
  belongs_to :table

  validates :table, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :start_time_less_than_end_time
  validate :not_overbooking

  scope :by_table_id, -> (table_id) { where(table_id: table_id) }
  scope :without, -> (id) { where(':id is NULL OR id <> :id', id: id) }

  scope :overbooking, -> (start_time, end_time) {
    where('(start_time <= :start_time AND end_time >= :end_time) OR (start_time >= :start_time AND end_time <= :end_time)',
      start_time: start_time, end_time: end_time)
  }

  private
  def not_overbooking
    unless Reservation.by_table_id(table_id).without(id).overbooking(start_time, end_time).empty?
      errors.add(:start_time, 'Invalid period.')
    end
  end

  def start_time_less_than_end_time
    unless start_time.blank? || end_time.blank? || start_time < end_time
      errors.add(:start_time, 'cannot be greater then end time')
    end
  end
end