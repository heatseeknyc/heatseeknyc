class Collaboration < ActiveRecord::Base
  belongs_to :user
  belongs_to :collaborator, :class_name => "User"
end
