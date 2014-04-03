class TwinesController < ApplicationController
  def new
    @twine = Twine.new
  end

  def create
    @twine = Twine.find_or_create_by(twine_params)
    redirect_to twine_path(@twine)
  end

  def show
    @twine = Twine.find(params[:id])
  end

  private
    def twine_params
      params.require(:twine).permit(:name, :email)
    end

end
