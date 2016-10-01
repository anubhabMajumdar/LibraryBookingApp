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
    # #debugger
end
  # GET /bookings/1
  # GET /bookings/1.json
  def show
  	user=User.find(session[:user_id]).email    
    @showing_booking=Booking.where("name =?",user)
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
    current_date=Time.new.strftime('%Y-%m-%d')
    current_time=Time.new.strftime('%H:%M:%S')
    user=User.find(session[:user_id]).email
    @bookings=Booking.where("name = ? and (data > ? or (endtime >= ? and data =?))",user,current_date,current_time,current_date)
    ##debugger

  end

  def release
    current_time=Time.new
    current_date=current_time.strftime('%Y-%m-%d')
    current_timeout=current_time.strftime('%H:%M:%S')#the time of release
    @recordbookings = Booking.find(params[:format])
    #the date after today
    if Date.parse(@recordbookings.data.strftime('%Y-%m-%d')) < Date.parse(Time.new.strftime('%Y-%m-%d'))
    	@recordbookings.destory
    #the time before starttime 
    elsif Time.parse(@recordbookings.starttime.strftime('%H:%M:%S')) >Time.parse(Time.new.strftime('%H:%M:%S'))
    	@recordbookings.destory
    #the release time
    else 
    	endtime=timeslot(current_timeout)
    end

  end

  def search_room

    @rooms=Room.new
    # @all_room_id = Room.all.pluck(:id)

    # #debugger
  end


  def search
    @room = Room.new(room_params)
    @@req_rooms = Room.all
    # #debugger
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


  # POST /bookings
  # POST /bookings.json

  def create

    @booking = Booking.new(booking_params)
     @booking.name = User.find(session[:user_id]).email
     #name is in fact the email of the person who books the room (By Lei Zhang)
     @booking.bookday=Time.new
       #respond_to do |format|
    #if booking_params["date(2i)"].length==1
    #  bookdate=booking_params["date(1i)"]+"-0"+booking_params["date(2i)"]+"-"+booking_params["date(3i)"]+" 00:00:00"
    #else
    #  bookdate=booking_params["date(1i)"]+"-"+booking_params["date(2i)"]+"-"+booking_params["date(3i)"]+" 00:00:00"
    #end

    #-------------
    #Cannot undertand what the following two lines of code mean (Lei Zhang)
    #@booking.endtime = @bookdate.endtime+":00"
    #@booking.starttime = @bookdate.starttime+":00"
    #-------------


    #--------------
    #<begin> edit by Lei Zhang
    starttime_string = booking_params[:starttime]
    if starttime_string.length == 4
        starttime_string = "0" + starttime_string
    end
    endtime_string = booking_params[:endtime]
    if endtime_string.length == 4
        endtime_string = "0" + endtime_string
    end

    @booking.endtime = Time.parse("%04d-%02d-%02d %s:00" %[booking_params["date(1i)"], booking_params["date(2i)"], booking_params["date(3i)"], endtime_string])
    @booking.starttime = Time.parse("%04d-%02d-%02d %s:00" %[booking_params["date(1i)"], booking_params["date(2i)"], booking_params["date(3i)"], starttime_string])
    #<end> edited by Lei Zhang
    #--------------
    
    @bookingrecord=Booking.where("room_id= ? and date = ?",booking_params[:room_id],@booking.date)

    #-------------
    #<begin> edited by Lei Zhang
    #debugger
    duration = @booking.endtime - @booking.starttime
    if ((duration/1800 > 4) || (duration<0))
      flash[:danger] = "Cannot book for more that 2 hours or less than 0 hours"
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
        flash[:danger] = "Cannot book room now. Please try again later"
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
        startindex=(book.starttime.hour)*2+(book.starttime.min)/30
        endindex=(book.endtime.hour)*2+(book.endtime.min)/30
        while startindex<endindex
          timeslot[startindex]=1
          startindex=startindex+1
        end
        end
        insertstart=(booking.starttime.hour*2+booking.starttime.min)/30
        insertend=(booking.endtime.hour)*2+(booking.endtime.min)/30
        while insertstart<insertend
              if timeslot[insertstart]!=0
                return false
              end
              insertstart=insertstart+1
        end#while
        return true
    end#function

    def timeslot(current_timeout)

    end

    def timeslot_constrain()

    end

    def bookday_constrain
    	
    end
end
