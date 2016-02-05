class UsersController < ApplicationController
  include UserControllerHelper
  before_action :authenticate_user!, except: [:demo, :judges_login]

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_without_password(user_params)
    @collaboration = current_user.collaborations.where(collaborator_id: @user.id).first
    redirect_to "/users/#{current_user.id}/collaborations/#{@collaboration.id}"
  end

  def index
    if current_user.permissions <= 50
      @users = User.all
    else
      redirect_to current_user
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      redirect_to "/users"
    else
      @user
      render action: 'new'
    end
  end

  def show
    respond_to do |f|
      f.html do 
        if current_user.permissions <= 50 
          render :permissions_show 
        else
          render :show
        end
      end
      f.json do
        @readings = current_user.get_latest_readings(168)
        render json: @readings
      end
    end
  end

  def download_pdf
    writer = PDFWriter.new_from_user_id(params[:id])

    file = writer.generate_pdf
    filename = writer.filename
    type = writer.content_type

    send_data(file, filename: filename, type: type)
  end

  def search
    @query = params[:q]
    @results = current_user.search(@query)
    
    respond_to do |f|
      f.html do
        if @results.empty?
          flash[:error] = "Unable to find user #{@query}."
          redirect_to current_user
        end
      end
      f.js
    end
  end

  def live_update
    user = User.find_by(first_name: "Live Update")
    # commenting this out so the number of readings doesn't suddenly drop
    # after having run for a minute
    # also, code is too slow, need a faster solution
    # if user.readings.count > 75
    #   user.readings.slice(0..-50).each do |r| 
    #     r.destroy 
    #   end
    # end

    respond_to do |f|
      f.html
      f.json do
        @readings = current_user.live_readings
        # @readings = current_user.readings.order('id ASC').limit(50)
        render json: @readings
      end
    end
  end

  def demo
    demo = User.demo_lawyer

    sign_in(demo)
    redirect_to user_path(demo)
  end

  def judges_login
    judge = User.find_by(last_name: params[:last_name])
    sign_in(judge)
    redirect_to user_path(judge)
  end

  private
    def user_params
      params.require(:user).permit([
        :first_name, 
        :last_name, 
        :address,
        :email,
        :phone_number,
        :zip_code,
        :permissions,
        :twine_name
      ])
    end
end
