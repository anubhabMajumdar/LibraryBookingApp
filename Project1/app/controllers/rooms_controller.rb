class RoomsController < ApplicationController
  before_action :allowed_user

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
    @user = User.find(session[:user_id])
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    set_room
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  def view_room_history
    @booking=Booking.where("room_id =?", Room.find(params[:id]).room_id)
    @user = User.find(session[:user_id])
    #this means all booking records of this room
    #redirect_to view_room_history_path
  end

  # GET /rooms/1/edit
  def edit
    @room=Room.find(params[:id])
    set_room
    #maybe a bug here
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    # respond_to do |format|
      if @room.save
        # format.html { redirect_to @room, notice: 'Room was successfully created.' }
        # format.json { render :show, status: :created, location: @room }
        flash[:success] = "Room successfully added"
        redirect_to admin_manage_room_path
      else
        # format.html { render :new }
        # format.json { render json: @room.errors, status: :unprocessable_entity }
        flash[:danger] = "Room couldn't be added. Please try again"
        render 'new'
      end
    # end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
      set_room
      if @room.update(room_params)
        flash[:success] = "Room successfully updated"
        redirect_to rooms_path
      else
        flash[:danger] = "Room couldn't be updated. Please try again"
        render 'new'
      end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    set_room
    current_time=Time.new.strftime('%Y-%m-%d %H:%M:%S')
    @record=Booking.where("room_id= ? and starttime > ?",@room.room_id,current_time)
    @record.each do |booking|
    booking.destroy
    end
    @room.destroy

    flash[:success] = "Room successfully removed"
    redirect_to rooms_path

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:room_id, :building, :size)
    end
end
