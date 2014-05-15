class Reservation < ActiveRecord::Base
  validates :table_number, presence: true, numericality: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :start_time, :end_time, overlap: { scope: 'table_number', exclude_edges: [:start_time, :end_time] }
  validate :start_time_cannot_be_greater_than_end_time

  protected
  def start_time_cannot_be_greater_than_end_time
      errors.add(:start_time, 'cannot be greater than end time') if start_time.blank? && end_time.blank? && start_time > end_time
  end
end