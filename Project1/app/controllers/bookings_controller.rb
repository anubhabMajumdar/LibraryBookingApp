class BookingsController < ApplicationController
  before_action :allowed_user
  #before_action :set_booking, only: [:show, :edit, :update, :destroy]
  @@req_rooms=nil
  require'time'
  @@hello=nil
  # @@curuser = User.find(session[:user_id])
  # GET /bookings
  # GET /bookings.json
  def index
    @newbooking=Booking.new
    if @@req_rooms
      @bookings=@@req_rooms
    # puts @tan
    else
      @bookings = Room.new
    end
    # @hours = ["00:00", "00:30" ]
    @hours = []
    (0..23).each do |i|
      ["00", "30"].each do |j|
        @hours.push("#{i}:#{j}")
        end
    end
    @roomids = Room.all.pluck(:room_id)
    # debugger
end
  # GET /bookings/1
  # GET /bookings/1.json
  def show
    admin="admin"
    sql="select * from bookings"# where username ='#{admin}'"
    @showing_booking=Booking.find_by_sql(sql)
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit

  end


  def cancel
    @bookings_cancel= Booking.find(params[:format])
    @bookings_cancel.destroy
    redirect_to release_room_path



  end

  def release_room
    current_time=Time.new
    admin="admin"
    sql="select * from bookings where username ='#{admin}'and date >='#{current_time}'"
    @bookings=Booking.find_by_sql(sql)
    #debugger

  end

  def release
    current_time=Time.new
    @recordbookings = Booking.find(params[:format])
    hours=current_time.hour
    minute=current_time.min
    timeslot=hours*2+minute/30
    @recordbookings.endtime=timeslot
    @recordbookings.update(entime: timeslot)
    redirect_to show_bookings_path

  end

  def search_room

    @rooms=Room.new
    # @all_room_id = Room.all.pluck(:id)

    # debugger
  end


  def search
    @room = Room.new(room_params)
    @@req_rooms = Room.all
    # debugger
    if @room.size!=""
      @@req_rooms = @@req_rooms.where(size: @room.size).all
    end
    if @room.building!=""
      @@req_rooms = @@req_rooms.where(building: @room.building).all
    end
    if @room.room_id != ""
      @@req_rooms = @@req_rooms.where(room_id: @room.room_id).all
    end
    redirect_to bookings_path
  end


 def save_room
   #obtain username
    @newbooking = Booking.new(booking_params)
    @newbooking.bookday="2016-08-09"##how to store bookday
    @newbooking.username="user"
    debugger
    if @newbooking.save
       puts 'Booking was successfully created.'
       redirect_to show_bookings_path
    end

 end

  # POST /bookings
  # POST /bookings.json

  def create

    @booking = Booking.new(booking_params)
     @booking.username = User.find(session[:user_id]).email
     @booking.bookday=Time.new
       #respond_to do |format|
    if booking_params["date(2i)"].length==1
      bookdate=booking_params["date(1i)"]+"-0"+booking_params["date(2i)"]+"-"+booking_params["date(3i)"]+" 00:00:00"
    else
      bookdate=booking_params["date(1i)"]+"-"+booking_params["date(2i)"]+"-"+booking_params["date(3i)"]+" 00:00:00"
      end
    @booking.endtime = @booking.endtime+":00"
    @booking.starttime = @booking.starttime+":00"

    @bookingrecord=Booking.where("room_id= ? and date = ?",booking_params[:room_id],bookdate)
      if (Time.parse(@booking.endtime)-Time.parse(@booking.starttime))/1800 > 4 ||Time.parse(@booking.endtime)-Time.parse(@booking.starttime)<0
        flash[:danger] = "Cannot book for more that 2 hours"
        redirect_to bookings_path
      elsif not (timeconstrain(@bookingrecord,@booking))
        flash[:danger] = "The room is booked during that period. Try another room or another time"
        redirect_to bookings_path
      else
        # respond_to do |format|
        #    if @booking.save
        #     format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
        #     format.json { render :show, status: :created, location: @booking }
        #   else
        #     format.html { render :new }
        #     format.json { render json: @booking.errors, status: :unprocessable_entity }
        #    end
        # end
        if @booking.save
          flash[:success] = "Room successfully booked"
        # redirect_to bookings_path
          redirect_to bookings_path
        else
          flash[:danger] = "Cannot book room now. Please try later"
          redirect_to bookings_path
        end
        end
 end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:room_id, :username, :string, :bookday, :date, :starttime, :endtime)
    end

    def room_params
      params.require(:room).permit(:size, :building,:room_id)
    end

    def timeconstrain(bookingrecord,booking )
        timeslot=Array.new(48,0)
        bookingrecord.each do |book|
        startindex=(Time.parse(book.starttime).hour)*2+(Time.parse(book.starttime).min)/30
        endindex=(Time.parse(book.endtime).hour)*2+(Time.parse(book.endtime).min)/30
        while startindex<endindex
          timeslot[startindex]=1
          startindex=startindex+1
        end
        end
        insertstart=(Time.parse(booking.starttime).hour)*2+(Time.parse(booking.starttime).min)/30
        insertend=(Time.parse(booking.endtime).hour)*2+(Time.parse(booking.endtime).min)/30
        while insertstart<insertend
              if timeslot[insertstart]!=0
                return false
              end
              insertstart=insertstart+1
        end#while
        return true
    end#function
end
