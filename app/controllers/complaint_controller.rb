class ComplaintController < ApplicationController
  def index
    @complaints = Complaint.where("id < 200001 AND latitude IS NOT NULL").pluck(:latitude, :longitude)
  end


  def complaints_ajax
    
  end
end