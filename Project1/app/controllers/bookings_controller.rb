class BookingsController < ApplicationController
  before_action :allowed_user
  #before_action :set_booking, only: [:show, :edit, :update, :destroy]
  @@req_rooms=nil
  require'time'
  @@hello=nil
  @@bookinfomail=nil

  # @@curuser = User.find(session[:user_id])
  # GET /bookings
  # GET /bookings.json
  def index
    @newbooking=Booking.new
    @all_bookings = Booking.new
    if @@req_rooms
      @bookings=@@req_rooms

      room_ids = []
      @bookings.each do |i|
        room_ids.push(i.room_id)
      end
      @all_bookings = Booking.where(room_id: room_ids).all
      # debugger

      @booking_matrix = []
      cur_date = Time.now
      # temp = "%04d-%02d-%02d 00:00:00" %[cur_date.year, cur_date.month, cur_date.day]

      (1..7).each do |k|
        room_ids.each do |er|
          temp = "%04d-%02d-%02d 00:00:00" %[cur_date.year, cur_date.month, cur_date.day]
          temparr = @all_bookings.where(room_id: er, date: temp).all
          @booking_matrix.push(get_array(temparr))

        end
        cur_date = cur_date + (24*60*60)
      end

      # debugger
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
    @loginuser=User.find(session[:user_id])
    @users=User.all.pluck(:email)
    # #debugger
  end

  def get_array(all_bookings)
    timeslot=Array.new(48,0)
    all_bookings.each do |book|
      startindex=(book.starttime.hour)*2+(book.starttime.min)/30
      endindex=(book.endtime.hour)*2+(book.endtime.min)/30
      while startindex<endindex
        timeslot[startindex]=1
        startindex=startindex+1
      end
    end
    return timeslot
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


######release room
  def release_room

    current_time=Time.new
    current_date=current_time.strftime('%Y-%m-%d')
    user=User.find(session[:user_id]).email
    #debugger
    @bookings=Booking.where("name = ? and endtime >= ?",user,current_time)
    ##debugger

  end


  def release
    current_time=Time.new
    current_date=current_time.strftime('%Y-%m-%d')
    current_timeout=current_time.strftime('%H:%M:%S')#the time of release
    @recordbookings = Booking.find(params[:format])
    #debugger
    #the time before starttime 
    if @recordbookings.starttime > current_time
    	@recordbookings.destroy
    #the release time
    else 
    	endtime=timeslot(current_time)
      @recordbookings.update(endtime: endtime)
    end
    #debugger
    if User.find(session[:user_id]).Admin
      redirect_to all_user_url
    else
      redirect_to my_booking_history_url
    end


  end

######search room by some keywords
  def search_room
    @rooms=Room.new
    

    # #debugger
  end

  def room_availability_by_date

    @req_date = booking_date
    temp = "%04d-%02d-%02d 00:00:00" %[@req_date["date(1i)"], @req_date["date(2i)"], @req_date["date(3i)"]]

    @bookings=@@req_rooms
    room_ids = []
    @bookings.each do |i|
      room_ids.push(i.room_id)
    end
    @all_bookings = Booking.where(room_id: room_ids, date: temp).all


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
    flag=0
    @@bookinfomail = Booking.new(booking_params)
    @booking = Booking.new(booking_params)
    @user=User.find(session[:user_id])
    if not @user.Admin
       # debugger
       @booking.name = User.find(session[:user_id]).email
       flag=1
    end
     #name is in fact the email of the person who books the room (By Lei Zhang)
     @booking.bookday=Time.new
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
    #debugger
    #<end> edited by Lei Zhang
    #--------------
    @bookingrecord=Booking.where("room_id= ? and date = ?",booking_params[:room_id],@booking.date)
    @record=Booking.where("name=? and date = ?", @booking.name,@booking.date)
    #-------------
    #<begin> edited by Lei Zhang
    #debugger
    duration = @booking.endtime - @booking.starttime
    if ((duration/1800 > 4) || (duration<=0))
      flash[:danger] = "Cannot book for more that 2 hours or less than 0 hours"
      redirect_to bookings_path
    elsif not (timeconstrain(@bookingrecord,@booking))
      flash[:danger] = "The room is booked during that period. Try another room or another time"
      redirect_to bookings_path
    elsif (@booking.starttime <= Time.new) ||((Time.parse(@booking.date.strftime('%Y-%m-%d'))-Time.parse(Time.new.strftime('%Y-%m-%d'))).round/(3600*24)>7)
      flash[:danger] = "The time period is not correct"
      redirect_to bookings_path
    elsif (flag==1)&&( not (bookroom_constrain(@record,@booking.starttime,@booking.endtime)))
      flash[:danger] = "A library member can reserve only one room at a particular date and time"
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
        #debugger
        flash[:success] = "Room successfully booked"
      # redirect_to bookings_path
      #   redirect_to bookings_path
        redirect_to send_mail_path
      else
        flash[:danger] = "Cannot book room now. Please try again later"
        redirect_to bookings_path
      end
    end
 end


  def send_mail

  end

  def dispatch_mail
    # debugger
    # UsermailerMailer.welcome_email(params[:email]).deliver_now
    UsermailerMailer.notification_email(@@bookinfomail, params[:email]).deliver_now
    redirect_to send_mail_path
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
      params.require(:booking).permit(:room_id, :name, :string, :bookday, :date, :starttime, :endtime)
    end

    def booking_date
      params.require(:booking).permit(:date)
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
        insertstart=(booking.starttime.hour)*2+(booking.starttime.min)/30
        insertend=(booking.endtime.hour)*2+(booking.endtime.min)/30
        while insertstart<insertend
              if timeslot[insertstart]!=0
                return false
              end
              insertstart=insertstart+1
        end#while
        return true
    end#function

    def timeslot(current_time)
        current_time+=60-current_time.sec
        if (current_time.min % 30) != 0
          current_time+=60*(30-current_time.min%30)
        end
        return current_time
    end

 

    def bookroom_constrain(record,starttime,endtime)
    	  timeslot=Array.new(48,0)
        record.each do |book|
        startindex=(book.starttime.hour)*2+(book.starttime.min)/30
        endindex=(book.endtime.hour)*2+(book.endtime.min)/30
        while startindex<endindex
          timeslot[startindex]=1
          startindex=startindex+1
        end
        end
        insertstart=(starttime.hour)*2+(starttime.min)/30
        insertend=(endtime.hour)*2+(endtime.min)/30
        while insertstart<insertend
              if timeslot[insertstart]!=0
                return false
              end
              insertstart=insertstart+1
        end#while
        return true
    end
end
