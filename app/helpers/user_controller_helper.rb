module UserControllerHelper
  def render_collaborators_for(user)
    render "collaborations" if !user.collaborations.empty? 
  end
end