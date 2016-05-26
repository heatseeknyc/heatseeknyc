module Admin
  class BuildingsController < AdminController
    before_action :load_building, only: [:edit, :update]

    def index
      @buildings = Building.all
    end

    def create
    end

    def update
      if @building.update_attributes(building_params)
        flash[:notice] = "Page was successfully updated."
        redirect_to(action: "edit", id: @building)
      else
        errors = @building.errors.full_messages.to_sentence
        flash[:error] = "Update failed due to: #{errors}"
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
  end
end
