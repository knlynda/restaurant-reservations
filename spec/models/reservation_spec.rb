require 'spec_helper'

describe Reservation do
  it { should belong_to(:table) }

  context 'validation' do
    it { should validate_presence_of(:table) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    it 'should not be valid booking table when start time less then end time' do
      expect(build(:reservation, start_time: 1.hour.since, end_time: 1.hour.ago)).not_to be_valid
    end

    context 'overbooking' do
      let(:reservation) { create(:reservation) }

      context 'on create' do
        let(:tested_reservation) { build(:reservation, table: reservation.table) }

        it 'should be valid booking the same table before existing reservation' do
          tested_reservation.start_time = reservation.start_time.ago(1.hour)
          tested_reservation.end_time = reservation.start_time

          expect(tested_reservation).to be_valid
        end

        it 'should be valid booking the same table before existing reservation' do
          tested_reservation.start_time = reservation.start_time.ago(2.hours)
          tested_reservation.end_time = reservation.start_time.ago(1.hour)

          expect(tested_reservation).to be_valid
        end

        it 'should be valid booking the same table after existing reservation' do
          tested_reservation.start_time = reservation.end_time
          tested_reservation.end_time = reservation.end_time.since(1.hour)

          expect(tested_reservation).to be_valid
        end

        it 'should be valid booking the same table after existing reservation' do
          tested_reservation.start_time = reservation.end_time.since(1.hour)
          tested_reservation.end_time = reservation.end_time.since(2.hours)

          expect(tested_reservation).to be_valid
        end

        it 'should valid booking the other table at the same time with previous table' do
          tested_reservation.table = create(:table)
          tested_reservation.start_time = reservation.start_time
          tested_reservation.end_time = reservation.end_time

          expect(tested_reservation).to be_valid
        end

        it 'should not be valid booking the same table at the same time' do
          tested_reservation.table = reservation.table
          tested_reservation.start_time = reservation.start_time
          tested_reservation.end_time = reservation.end_time

          expect(tested_reservation).not_to be_valid
        end

        it 'should not be valid booking the same table started and finished in time range of existing reservation' do
          tested_reservation.start_time = reservation.start_time.since(10.minutes)
          tested_reservation.end_time = reservation.end_time.ago(10.minutes)

          expect(tested_reservation).not_to be_valid
        end

        it 'should not be valid booking the same table started before and finished in time range of existing reservation' do
          tested_reservation.start_time = reservation.start_time.ago(10.minutes)
          tested_reservation.end_time = reservation.start_time.since(10.minutes)

          expect(tested_reservation).not_to be_valid
        end

        it 'should not be valid booking the same table finished after but started in time range of existing reservation' do
          tested_reservation.start_time = reservation.end_time.ago(10.minutes)
          tested_reservation.end_time = reservation.end_time.since(10.minutes)

          expect(tested_reservation).not_to be_valid
        end

        it 'should not be valid booking the same table started before and finished after existing reservation time' do
          tested_reservation.start_time = reservation.start_time.ago(10.minutes)
          tested_reservation.end_time = reservation.end_time.since(10.minutes)

          expect(tested_reservation).not_to be_valid
        end
      end

      context 'on update' do
        it 'should be valid rebooking the same table in the same time' do
          expect(reservation).to be_valid
        end

        it 'should not be valid rebooking same table in the same time with other reservation' do
          other_reservation = create(:reservation, table: reservation.table,
                                     start_time: reservation.end_time, end_time: reservation.end_time.since(1.hour))

          reservation.start_time = other_reservation.start_time
          reservation.end_time = other_reservation.end_time

          expect(reservation).not_to be_valid
        end
      end
    end
  end
end