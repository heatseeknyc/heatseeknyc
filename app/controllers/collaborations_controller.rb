class CollaborationsController < ApplicationController
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
end
