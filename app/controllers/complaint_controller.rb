class ComplaintController < ApplicationController
  def index
    @complaints = Complaint.where("id < 2700").pluck(:latitude, :longitude)
  end
end
