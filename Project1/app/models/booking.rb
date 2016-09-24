class Booking < ApplicationRecord
  validate :endtime, :starttime,  on: :create

  def time_period
    errors.add("Bookings can be made for 2 hour slots") unless Integer(endtime)-Integer(startime)<=4

  end
end
