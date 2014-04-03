class CollaborationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @collaboration = current_user.collaborations.build(:collaborator_id => params[:collaborator_id])
    
    if @collaboration.save
      flash[:notice] = "Added collaborator."
      redirect_to root_url
    else
      flash[:error] = "Unable to add collaborator."
      redirect_to root_url
    end
  end

  def destroy
    @collaboration = current_user.collaborations.find(params[:id])
    @collaboration.destroy
    flash[:notice] = "Ended Collaboration."
    redirect_to current_user
  end

  def show
    if current_user.has_collaboration?(params[:id])
      @user = User.find(Collaboration.find(params[:id]).collaborator_id)
      render "show"
    else
      flash[:error] = "You are not authorized to see that user's page."
      redirect_to current_user
    end
  end

end
