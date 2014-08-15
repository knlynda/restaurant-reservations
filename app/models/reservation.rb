class Reservation < ActiveRecord::Base
  belongs_to :table

  validates :table, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :start_time_less_than_end_time
  validate :not_overbooking

  scope :by_table_id, -> (table_id) { where(table_id: table_id) }
  scope :without, -> (id) { where(':id is NULL OR id <> :id', id: id) }

  scope :overbooking, -> (reservation) {
    by_table_id(reservation.table_id).without(reservation.id).
        where('(start_time <= :start_time AND end_time > :start_time)
               OR (start_time < :end_time AND end_time >= :end_time)
               OR (start_time > :start_time AND end_time < :end_time)',
              start_time: reservation.start_time, end_time: reservation.end_time)
  }

  private
  def not_overbooking
    errors.add(:start_time, 'Invalid period.') unless Reservation.overbooking(self).empty?
  end

  def start_time_less_than_end_time
    unless start_time.blank? || end_time.blank? || start_time < end_time
      errors.add(:start_time, 'cannot be greater then end time')
    end
  end
end