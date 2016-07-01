module Admin
  class BuildingsController < AdminController
    before_action :load_building, only: [:edit, :update]

    def index
      @buildings = Building.all
    end

    def create
      @building = Building.new(building_params)

      if @building.save
        flash[:notice] = "Successfully created."
        redirect_to admin_buildings_path
      else
        error_flash
        render action: "new"
      end
    end

    def update
      if @building.update_attributes(building_params)
        flash[:notice] = "Successfully updated."
        redirect_to(action: "edit", id: @building)
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
