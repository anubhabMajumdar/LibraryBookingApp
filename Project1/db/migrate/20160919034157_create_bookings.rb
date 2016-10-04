class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.string :room_id
      t.string :name
      t.timestamp :bookday
      t.datetime :date
      t.datetime :starttime
      t.datetime :endtime
      t.timestamps
    end
  end
end
