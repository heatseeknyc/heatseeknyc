class Reading < ActiveRecord::Base
  belongs_to :twine
  belongs_to :user

  def time_to_the_minute
    time = self.created_at.to_i
    seconds = time % 60
    time -= seconds
    Time.at(time)
  end
end