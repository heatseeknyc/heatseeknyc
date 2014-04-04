module UserControllerHelper
  def render_collaborators_for(user)
    render "users/collaborations" if !user.collaborations.empty?
  end
end