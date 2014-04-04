class Collaboration < ActiveRecord::Base
  include CollaborationHelper
  
  belongs_to :user
  belongs_to :collaborator, :class_name => "User"
  before_save :valid_relationship?
  validates :user_id, uniqueness: {scope: :collaborator_id}

  def valid_relationship?
    self.user_id != self.collaborator_id
  end

  def confirmed
    true #placeholder method until we add functionality for confirming lawyers
  end
end
