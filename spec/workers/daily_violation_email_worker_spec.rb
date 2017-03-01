require "spec_helper"

describe DailyViolationEmailWorker do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  let(:sensor1) { create(:sensor, user: user1) }
  let(:sensor2) { create(:sensor, user: user2) }
  let(:sensor3) { create(:sensor, user: user3) }

  before do
    reading(user1, sensor1, "2016-12-01 02:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 03:00:00", violation: false)
    reading(user1, sensor1, "2016-12-01 04:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 05:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 06:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 07:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 08:00:00", violation: false)
    reading(user1, sensor1, "2016-12-01 09:00:00", violation: true)

    reading(user2, sensor2, "2016-12-01 03:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 04:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 05:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 06:00:00", violation: false)
    reading(user2, sensor2, "2016-12-01 07:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 08:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 09:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 10:00:00", violation: false)

    reading(user3, sensor3, "2016-12-01 03:00:00", violation: false)
    reading(user3, sensor3, "2016-12-01 04:00:00", violation: false)
    reading(user3, sensor3, "2016-12-01 05:00:00", violation: false)
    reading(user3, sensor3, "2016-12-01 06:00:00", violation: false)
    reading(user3, sensor3, "2016-12-01 07:00:00", violation: false)
    reading(user3, sensor3, "2016-12-01 08:00:00", violation: false)
    reading(user3, sensor3, "2016-12-01 09:00:00", violation: false)
    reading(user3, sensor3, "2016-12-01 10:00:00", violation: false)
  end

  it "groups readings into violations of greater than 3 hours" do
    results = DailyViolationEmailWorker.new(
      start_at: DateTime.parse("2016-12-01 00:00:00"),
      end_at: DateTime.parse("2016-12-02 00:00:00"),
    ).perform

    binding.pry
  end

  def reading(user, sensor, time, violation:)
    create(:reading, user: user, sensor: sensor, created_at: DateTime.parse(time), violation: violation)
  end
end
