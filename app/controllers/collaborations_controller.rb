class CollaborationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:create, :destroy]

  def create
    @collaboration = @user.collaborations
      .build(:collaborator_id => params[:collaborator_id])

    respond_to do |f|
      f.js
      f.html do
        if @collaboration.save
          flash[:notice] = "Added collaborator."
          redirect_to user_path(current_user)
        else
          flash[:error] = "Unable to add collaborator."
          redirect_to user_path(current_user)
        end
      end
    end
  end

  def destroy
    @collaboration = current_user.collaborations.find(params[:id])
    @collaboration.destroy

    respond_to do |f|
      f.js
      f.html do 
        flash[:error] = "Ended Collaboration."
        redirect_to current_user
      end
    end
  end

  def show
    if current_user.has_collaboration?(params[:id])
      @user = User.find(Collaboration.find(params[:id]).collaborator_id)
      @analytics_page = "Viewed user page for #{@user.name}"

      respond_to do |f|
        f.html do
          render "show"
        end
        f.json do
          @readings = @user.last_weeks_readings
          render json: @readings
        end
      end
    else
      flash[:error] = "You are not authorized to see that user's page."
      redirect_to current_user
    end
  end

  private

    def load_user
      @user = User.find(params[:user_id])
    end

end
