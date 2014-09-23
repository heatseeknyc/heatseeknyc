class ComplaintController < ApplicationController
  # This is the coldmap
  def index
    respond_to do |f|
      f.html
      f.json do
        @complaints = Complaint.retrieve_all_by_zip_code
        render json: @complaints
      end
    end
    # old complaints for making heatmap
    # @complaints = Complaint.where("id < 1 AND latitude IS NOT NULL").pluck(:latitude, :longitude)
  end

  def query
    # @complaints = Concerns::ComplaintAjaxHelper.custom_query_from(params)  
  end

end