require 'spec_helper'

describe Reservation do
  it { should belong_to(:table) }

  context 'validation' do
    it { should validate_presence_of(:table) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    context 'overbooking' do
      let(:table) { create(:table) }
      let(:other_table) { create(:table) }
      let(:existing_reservation) { create(:reservation, table: table, start_time: 2.hours.ago, end_time: 2.hours.since) }

      it 'should be valid booking the same table before existing reservation' do
        reservation_params = {
            table: table,
            start_time: existing_reservation.start_time.ago(1.hour),
            end_time: existing_reservation.start_time
        }

        expect(build(:reservation, reservation_params)).to be_valid
      end

      it 'should be valid booking the same table after existing reservation' do
        reservation_params = {
            table: table,
            start_time: existing_reservation.end_time,
            end_time: existing_reservation.end_time + 1.hour
        }

        expect(build(:reservation, reservation_params)).to be_valid
      end

      it 'should valid booking the other table at the same time with previous table' do
        reservation_params = {
            table: other_table,
            start_time: existing_reservation.start_time,
            end_time: existing_reservation.end_time
        }

        expect(build(:reservation, reservation_params)).to be_valid
      end

      it 'should not be valid booking the same table at the same time' do
        reservation_params = {
            table: table,
            start_time: existing_reservation.start_time,
            end_time: existing_reservation.end_time
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end

      it 'should not be valid booking the same table started and finished at existing reservation time' do
        reservation_params = {
            table: table,
            start_time: existing_reservation.start_time.since(1.hour),
            end_time: existing_reservation.end_time.ago(1.hour)
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end

      it 'should not be valid booking the same table started before and finished at existing reservation time' do
        reservation_params = {
            table: table,
            start_time: existing_reservation.start_time.ago(1.hour),
            end_time: existing_reservation.start_time.since(1.hour)
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end

      it 'should not be valid booking the same table finished after but started at existing reservation time' do
        reservation_params = {
            table: table,
            start_time: existing_reservation.end_time.ago(1.hour),
            end_time: existing_reservation.end_time.since(1.hour)
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end

      it 'should not be valid booking the same table started before and finished after existing reservation time' do
        reservation_params = {
            table: table,
            start_time: existing_reservation.start_time.ago(1.hour),
            end_time: existing_reservation.end_time.since(1.hour)
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end
    end
  end
end