class Reservation < ActiveRecord::Base
  belongs_to :table

  validates :table, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :start_time_less_than_end_time
  validate :not_overbooking

  scope :by_table_id, -> (table_id) { where(table_id: table_id) }
  scope :without_self, ->(id) {where('id !=?', id) if id}

  scope :overbooking, -> (start_time, end_time) {
    where('(start_time <= :start_time AND end_time > :start_time)
            OR (start_time < :end_time AND end_time >= :end_time)
            OR (start_time > :start_time AND end_time < :end_time)',
      start_time: start_time, end_time: end_time)
  }

  private
  def not_overbooking
    unless Reservation.by_table_id(table_id).without_self(id).overbooking(start_time, end_time).empty?
      errors.add(:start_time, 'invalid period given')
    end
  end

  def start_time_less_than_end_time
    if start_time && end_time && start_time >= end_time
      errors.add(:start_time, 'cannot be greater then end time')
    end
  end
end