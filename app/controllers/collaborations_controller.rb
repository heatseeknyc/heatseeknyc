class CollaborationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @collaboration = current_user.collaborations.build(:collaborator_id => params[:collaborator_id])
    
    respond_to do |f|
      f.js
      f.html do
        if @collaboration.save
          flash[:notice] = "Added collaborator."
          redirect_to root_url
        else
          flash[:error] = "Unable to add collaborator."
          redirect_to root_url
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
      respond_to do |f|
        f.html do
          @user = User.find(Collaboration.find(params[:id]).collaborator_id)
          render "show"
        end
        f.json do
          @readings = User.find(Collaboration.find(params[:id]).collaborator_id).readings.order("id DESC")
          render json: @readings
        end
      end
    else
      flash[:error] = "You are not authorized to see that user's page."
      redirect_to current_user
    end
  end

end
