class User < ActiveRecord::Base
  has_many :readings

  def twine
    
  end
end
