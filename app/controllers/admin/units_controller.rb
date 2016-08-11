module Admin
  class UnitsController < AdminController
    before_action :load_building
    before_action :load_unit, only: [:edit, :update]

    def index
      @units = @building.units
    end

    def create
      params[:unit][:building_id] ||= @building.id
      @unit = Unit.new(unit_params)

      if @unit.save
        flash[:notice] = "Successfully created."
        redirect_to admin_building_units_path(@building)
      else
        error_flash
        render action: "new"
      end
    end

    def update
      if @unit.update_attributes(unit_params)
        flash[:notice] = "Successfully updated."
        redirect_to admin_building_units_path(@building)
      else
        error_flash
        render action: "edit"
      end
    end

    private

    def unit_params
      params.require(:unit).permit(:building_id,
                                   :name,
                                   :floor,
                                   :description)
    end

    def load_building
      @building = Building.find(params[:building_id])
    end

    def load_unit
      @unit = Unit.find(params[:id])
    end

    def error_flash
      flash.now[:error] = "Save failed due to errors."
    end
  end
end
