class UsersController < ApplicationController
  include UserControllerHelper
  before_action :authenticate_user!, except: [:demo, :addresses]
  before_action :authenticate_admin_user!, only: [:edit, :update]
  before_action :authenticate_super_user!, only: [:new, :create]
  before_action :load_user, only: [:edit, :update, :show]

  def edit
  end

  def update
    if user_params[:permissions] &&
       user_params[:permissions].to_i < current_user.permissions
      render plain: "Unauthorized", status: :unauthorized
    else
      @user.update_without_password(user_params)
      MixpanelSyncWorker.new.perform(@user.id, 'is_new_user' => false) # TODO background
      @collaboration = current_user.collaborations
                                  .where(collaborator_id: @user.id)
                                  .first
      if @user.valid?
        if @collaboration || current_user.admin_or_more_powerful?
          redirect_to user_path(@user)
        else
          redirect_to user_path(current_user)
        end
      else
        render :edit
      end
    end
  end

  def index
    if current_user.team_member_or_more_powerful?
      @users = User.all
    else
      redirect_to current_user
    end
  end

  def new
    @user = User.new
  end

  def create
    stripped_params = user_params.inject({}) do |params, (key, value)|
      params[key.try(:to_sym) || key] = value.try(:strip) || value
      params
    end

    @user = User.new_with_building(stripped_params)

    if @user.valid?
      @user.save

      MixpanelSyncWorker.new.perform(@user.id, 'is_new_user' => true) # TODO background

      if @user.email !~ /heatseek\.org$/
        password_reset_token = @user.generate_password_reset_token
        UserMailer.welcome_email(recipient_id: @user.id, password_reset_token: password_reset_token).deliver
      end

      redirect_to users_path
    else
      @user
      render action: "new"
    end
  end

  def show
    respond_to do |f|
      f.html do
        if @user.tenant? && current_user.able_to_see_tenant(@user)
          @analytics_page = "User Dashboard"
          render :show
        elsif @user.advocate_or_more_powerful? && current_user.able_to_see_non_tenant(@user)
          @analytics_page = "Advocate Dashboard"
          render :permissions_show
        else
          flash[:error] = "You are not authorized to see that user's page."
          redirect_to user_path(current_user)
        end
      end
      f.json do
        @readings = @user.get_latest_readings(168)
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
      bypass_sign_in @user
      flash[:notice] = "Password changed."
      redirect_to root_path
    else
      render "edit_password", status: 401
    end
  end

  def download_pdf
    years = params[:years].map(&:to_i)

    @writer = PDFWriter.new_from_user_id(params[:id], years: years)
    filename = @writer.filename

    puts @writer.table_array

    render pdf: filename,
      disposition: "attachment"
  end

  def download_csv
    writer = CSVWriter.new(params[:id])

    file = writer.generate_csv
    send_data(file, filename: writer.filename, type: "text/csv")
  end

  def search
    @query = params[:q]
    @user = User.find(params[:search_user_id])
    @results = @user.search(@query)

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
        :twine_name,
        :apartment,
        :password,
        :password_confirmation,
        :permissions,
        :sensor_codes_string,
        :set_location_data,
        :paying_user,
        :at_risk,
        :sms_alert_number,
        :summer_user,
      ])
    end

    def authenticate_admin_user!
      return if current_user.admin_or_more_powerful?
      redirect_to root_path
    end

    def authenticate_super_user!
      return if current_user.super_user?
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
