class AdminController < ApplicationController
  before_action :validate_admin_user!

  private

  def validate_admin_user!
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
end
