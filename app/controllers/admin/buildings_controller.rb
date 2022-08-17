module Admin
  class BuildingsController < AdminController
    before_action :load_building, only: [:edit, :update]

    def index
      @buildings = Building.all
      respond_to do |format|
        format.html { @buildings }
        format.json { render json: @buildings.where("street_address like ?", "%#{params[:term]}%").map(&:street_address) }
      end
    end

    def create
      @building = Building.new(building_params)
      @building.set_location_data

      if @building.save
        flash[:notice] = "Successfully created."
        redirect_to admin_buildings_path
      else
        error_flash
        render action: "new"
      end
    end

    def update
      if @building.update(building_params)
        @building.set_location_data
        @building.save
        flash[:notice] = "Successfully updated."
        redirect_to admin_buildings_path
      else
        error_flash
        render action: "edit"
      end
    end

    private

    def building_params
      params.require(:building).permit(:property_name,
                                       :description,
                                       :street_address,
                                       :zip_code,
                                       :bin,
                                       :bbl)
    end

    def load_building
      @building = Building.find(params[:id])
    end

    def error_flash
      flash.now[:error] = "Save failed due to errors."
    end
  end
end
