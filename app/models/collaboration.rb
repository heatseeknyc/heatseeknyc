class Collaboration < ActiveRecord::Base
  belongs_to :user
  belongs_to :collaborator, :class_name => "User"
  before_save :valid_relationship?

  def valid_relationship?
    self.user_id != self.collaborator_id
  end

  def confirmed
    true #placeholder method until we add functionality for confirming lawyers
  end
end
