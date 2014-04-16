module UserControllerHelper
  def render_collaborators_for(user)
    render "users/collaborations" if !user.collaborations.empty?
  end

  def render_demo_logout_button_for(user)
    render "users/demo_logout_button" if user.is_demo_user?
  end
end