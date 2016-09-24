class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.string :room_id
      t.string :username
      t.string :string
      t.timestamp :bookday
      t.datetime :date
      t.string :starttime
      t.string :endtime

      t.timestamps
    end
  end
end
