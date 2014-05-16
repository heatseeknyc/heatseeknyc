class ComplaintController < ApplicationController
  def index
    @complaints = Complaint.where("id < 200001 AND latitude IS NOT NULL").pluck(:latitude, :longitude)
  end

  def query
    binding.pry
    @complaints = Concerns::ComplaintAjaxHelper.custom_query(params)  
  end
end