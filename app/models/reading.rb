class Reading < ActiveRecord::Base
  belongs_to :twine
  belongs_to :user
end