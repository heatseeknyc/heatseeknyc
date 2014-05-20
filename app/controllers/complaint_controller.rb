class ComplaintController < ApplicationController
  def index
    @complaints = Complaint.where("id < 1 AND latitude IS NOT NULL").pluck(:latitude, :longitude)
  end

  def query
    @complaints = Concerns::ComplaintAjaxHelper.custom_query_from(params)  
  end
end