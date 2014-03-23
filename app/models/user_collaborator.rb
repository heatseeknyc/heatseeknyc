class UserCollaborator < ActiveRecord::Base
  belongs_to :user
  belongs_to :collaborator, class_name: "User"
  validates :user_id, presence: true
  validates :collaborator_id, presence: true
end