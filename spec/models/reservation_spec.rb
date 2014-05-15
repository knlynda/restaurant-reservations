require 'spec_helper'

describe Reservation do
  it { should respond_to(:table_number) }
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }

  context 'validation' do
    it 'should be valid when all fields filled correctly' do
      expect(build(:reservation)).to be_valid
    end

    it 'should not be valid when table number is nil' do
      expect(build(:reservation, table_number: nil)).not_to be_valid
    end

    it 'should not be valid when start time is nil' do
      expect(build(:reservation, start_time: nil)).not_to be_valid
    end

    it 'should not be valid when end time is nil' do
      expect(build(:reservation, end_time: nil)).not_to be_valid
    end

    context 'overbooking' do
      let(:table_number) { rand(9) + 1 }
      let(:existing_reservation) { create(:reservation, table_number: table_number, start_time: 2.hours.ago,
                                          end_time: 2.hours.since) }

      it 'should be valid booking the same table before existing reservation' do
        reservation_params = {
            table_number: table_number,
            start_time: existing_reservation.start_time.ago(1.hour),
            end_time: existing_reservation.start_time
        }

        expect(build(:reservation, reservation_params)).to be_valid
      end

      it 'should be valid booking the same table after existing reservation' do
        reservation_params = {
            table_number: table_number,
            start_time: existing_reservation.end_time,
            end_time: existing_reservation.end_time + 1.hour
        }

        expect(build(:reservation, reservation_params)).to be_valid
      end

      it 'should valid booking the other table at the same time with previous table' do
        reservation_params = {
            table_number: existing_reservation.table_number + 1,
            start_time: existing_reservation.start_time,
            end_time: existing_reservation.end_time
        }

        expect(build(:reservation, reservation_params)).to be_valid
      end

      it 'should not be valid booking the same table at the same time' do
        reservation_params = {
            table_number: table_number,
            start_time: existing_reservation.start_time,
            end_time: existing_reservation.end_time
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end

      it 'should not be valid booking the same table started and finished at existing reservation time' do
        reservation_params = {
            table_number: table_number,
            start_time: existing_reservation.start_time.since(1.hour),
            end_time: existing_reservation.end_time.ago(1.hour)
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end

      it 'should not be valid booking the same table started before and finished at existing reservation time' do
        reservation_params = {
            table_number: table_number,
            start_time: existing_reservation.start_time.ago(1.hour),
            end_time: existing_reservation.start_time.since(1.hour)
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end

      it 'should not be valid booking the same table finished after but started at existing reservation time' do
        reservation_params = {
            table_number: table_number,
            start_time: existing_reservation.end_time.ago(1.hour),
            end_time: existing_reservation.end_time.since(1.hour)
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end

      it 'should not be valid booking the same table started before and finished after existing reservation time' do
        reservation_params = {
            table_number: table_number,
            start_time: existing_reservation.start_time.ago(1.hour),
            end_time: existing_reservation.end_time.since(1.hour)
        }

        expect(build(:reservation, reservation_params)).not_to be_valid
      end
    end
  end
end