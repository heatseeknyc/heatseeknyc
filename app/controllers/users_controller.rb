class UsersController < ApplicationController
  include UserControllerHelper
  before_action :authenticate_user!, except: [:demo, :addresses]
  before_action :authenticate_admin_user!, only: [:edit, :update]
  before_action :load_user, only: [:edit, :update]

  def update
    if user_params[:permissions] &&
       user_params[:permissions].to_i < current_user.permissions
      render text: "Unauthorized", status: :unauthorized
    else
      @user.update_without_password(user_params)
      @collaboration = current_user.collaborations
                                  .where(collaborator_id: @user.id)
                                  .first
      if @collaboration
        redirect_to user_collaboration_path(current_user, @collaboration)
      else
        redirect_to user_path(current_user)
      end
    end
  end

  def index
    if current_user.permissions <= User::PERMISSIONS[:lawyer]
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
      render action: "new"
    end
  end

  def show
    respond_to do |f|
      f.html do
        if current_user.permissions <= User::PERMISSIONS[:lawyer]
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

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(password_params)
      sign_in @user, bypass: true
      flash[:notice] = "Password changed."
      redirect_to root_path
    else
      render "edit_password", status: 401
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

  # TODO: Extract this into a CSVWriter service to match PDFWriter and
  # declutter this controller
  def addresses
    pilot_2016 = Time.zone.parse("2015-10-01")..Time.zone.parse("2016-05-31")
    addresses = User.published_addresses(pilot_2016)
    header_row = ["address", "zip_code"]
    csv = addresses.clone.unshift(header_row)

    send_data(
      csv.map { |row| row.join(",") }.join("\n"),
      type: "text/csv; charset=utf-8; header=present",
      filename: "addresses.csv"
    )
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

    def authenticate_admin_user!
      return if current_user.permissions <= User::PERMISSIONS[:admin]
      redirect_to root_path
    end

    def load_user
      @user = User.find(params[:id])
    end

    def password_params
      params.require(:user).permit(:current_password,
                                   :password,
                                   :password_confirmation)
    end
end
