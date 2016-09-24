class BookingsController < ApplicationController
  #before_action :set_booking, only: [:show, :edit, :update, :destroy]
  require'time'
  @@hello=nil
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
    @newbooking=Booking.new
    if(@@hello!=nil)
      @bookings=@@hello
    puts @tan
  else

  end
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
   # debugger
  end

  def search
    #debugger
      @room = Room.new(room_params)
      currentime=Time.new
      time="2016-09-18"
      ab="select * from bookings where room_id in (select room_id from rooms where "
      if(@room.size!="")
        ab=ab+"size = '#{@room.size}'"
      end
      if(@room.size!=""&&@room.building!="")
        ab=ab+"and building ='#{@room.building}'"
      end
      if(@room.building!="")
        ab=ab+"building ='#{@room.building}'"
      end
      if((@room.size!=""&&@room.room_id!="")||(@room.building!=""&&@room.room_id!=""))
        ab=ab+"and room_id = '#{@room.room_id}'"
      end
      if(@room.room_id!="")
        ab=ab+" room_id = '#{@room.room_id}'"
      end

      ab="#{ab}) and bookday > '#{currentime.strftime('%Y-%m-%d')}'"

      @@hello=Booking.find_by_sql(ab)
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
     @booking.username="user"
     @booking.bookday=Time.new
     #debugger
       #respond_to do |format|
     @bookingrecord=Booking.where("room_id=? and date = ?",booking_params[:room_id],booking_params[:date])
      if (Time.parse(@booking.endtime)-Time.parse(@booking.starttime))/1800 > 4 ||Time.parse(@booking.endtime)-Time.parse(@booking.starttime)<0
        redirect_to bookings_path,notice: 'The input is wrong, Bookings can be made for 2 hour slots!!'
      elsif not (timeconstrain(@bookingrecord,@booking))
        redirect_to bookings_path,notice: 'The booking time is wrong, the time period is booked by others!!'
      else
        respond_to do |format|
           if @booking.save
            format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
            format.json { render :show, status: :created, location: @booking }
          else
            format.html { render :new }
            format.json { render json: @booking.errors, status: :unprocessable_entity }
           end
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
        while startindex<=endindex
          timeslot[starttime]=1
          startindex=startindex+1
        end
        end
        insertstart=(Time.parse(booking.starttime).hour)*2+(Time.parse(booking.starttime).min)/30
        insertend=(Time.parse(booking.endtime).hour)*2+(Time.parse(booking.endtime).min)/30
        while insertstart<=insertend
              if timeslot[insertstart]!=0
                return false
              end
              insertstart=insertstart+1
        end#while

    end#function
end
