module UserControllerHelper
  def resource_name
    :user
  end

  def resource
    @user
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end