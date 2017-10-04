class SensorsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_sensor, only: [:show, :edit, :update, :destroy]
  # GET /sensors
  # GET /sensors.json
  def index
    @sensors = Sensor.order(created_at: :desc).all
  end

  def assigned
    @sensors = Sensor.order(created_at: :desc).where.not(user_id: nil)
  end

  # GET /sensors/1
  # GET /sensors/1.json
  def show
    @sensor = Sensor.find(params[:id])
  end

  # GET /sensors/new
  def new
    @sensor = Sensor.new
  end

  # GET /sensors/1/edit
  def edit
    @sensor = Sensor.find(params[:id])
    @email = @sensor.user.try(:email)
  end

  # POST /sensors
  # POST /sensors.json
  def create
    @sensor = Sensor.find_or_create_from_params(sensor_params)
    redirect_to sensor_path(@sensor)
  end

  def unassign
    @sensor = Sensor.find(params[:id])
    @sensor.update!(user_id: nil)
    redirect_to :back, notice: "Sensor unassigned"
  end

  def update
    @sensor = Sensor.find(params[:id])

    if @sensor.update(update_sensor_params)
      redirect_to sensors_path, notice: "updated sensor"
    else
      render :edit
    end
  end

  # DELETE /sensors/1
  # DELETE /sensors/1.json
  def destroy
    @sensor.destroy
    respond_to do |format|
      format.html { redirect_to sensors_url }
      format.json { head :no_content }
    end
  end

  def not_reporting
    @sensors = Sensor.joins(:user)
                .joins(:readings)
                .group("sensors.id")
                .select("sensors.*, MAX(readings.created_at) AS last_reading_date")
                .having("MAX(readings.created_at) > ?", 6.months.ago)
                .having("MAX(readings.created_at) <= ?", 6.hours.ago)
                .order("MAX(readings.created_at) desc")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensor
      @sensor = Sensor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensor_params
      # TODO: fix this anti-pattern and figure out how to do nested model strong params
      params.require(:sensor).permit(:name, :email)
    end

    def update_sensor_params
      params.require(:sensor).permit(:user_id)
    end

    def authenticate_admin!
      if !signed_in?
        redirect_to welcome_index_path
      elsif !current_user.admin_or_more_powerful?
        redirect_to current_user 
      end
    end
end
