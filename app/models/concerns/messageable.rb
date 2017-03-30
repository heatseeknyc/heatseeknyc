module Messageable
  module InstanceMethods
    def get_possessive(user)
      self.id == user.id ? 'your' : "#{user.first_name}'s"
    end
  end
end
