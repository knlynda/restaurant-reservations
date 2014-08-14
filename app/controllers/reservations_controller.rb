class ReservationsController < ApplicationController
  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.save
    redirect_to table_path(@reservation.table)
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])

    if @reservation.update(reservation_params)
      redirect_to table_path @reservation.table
    else
      redirect_to edit_table_reservation_path(@reservation.table, @reservation)
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    redirect_to table_path(@reservation.table, @reservation)
  end

  def reservation_params
    params.require(:reservation).permit(:start_time, :end_time, :table_id)
  end
end
