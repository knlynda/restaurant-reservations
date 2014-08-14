class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.references :table

      t.timestamps
    end
  end
end