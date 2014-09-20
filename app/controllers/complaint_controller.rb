class ComplaintController < ApplicationController
  # This is the coldmap
  def index
    # @complaints = Complaint.where("id < 1 AND latitude IS NOT NULL").pluck(:latitude, :longitude)
  end

  def query
    # @complaints = Concerns::ComplaintAjaxHelper.custom_query_from(params)  
  end

  # this method will be used to show our sensors once the schema is corrected
  # def sensors
  #   respond_to do |f|
  #     f.html
  #     f.json do
  #       @sensor_geo_locations =
  #       render json: @sensor_geo_locations
  #     end
  #   end
  # end
end