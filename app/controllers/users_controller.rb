class UsersController < ApplicationController
  include UserControllerHelper
  before_action :authenticate_user!, except: [:demo, :judges_login]

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    flash[:success] = {}
    user_params.each do |key, value|
      flash[:success][key.to_sym] = "Successfully changed #{key.to_s.gsub(/_/, " ")} to #{value}" if @user.send(key).to_s != value
    end

    @user.update_without_password(user_params)

    flash[:error] = {}
    if @user.errors.messages
      @user.errors.messages.each do |key, value|
        flash[:success][key.to_sym] = nil
        flash[:error][key.to_sym] = "Error changing #{key.to_s.gsub(/_/, " ")}: #{value.join("")}"
      end
    end
    # flash[:notice] = "Successfully updated sensor code(s) to be #{@user.sensor_codes_string}"
    # redirect_to "/users/#{@user.id}/edit"
    redirect_to edit_user_path(@user)
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
        :zip_code,
        :permissions,
        :sensor_codes_string
      ])
    end
end
