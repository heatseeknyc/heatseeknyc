require "spec_helper"

describe DailyViolationEmailWorker do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }

  let(:advocate1) { create(:user, :advocate) }
  let(:advocate2) { create(:user, :admin) }
  let(:advocate3) { create(:user, :advocate) }

  let(:sensor1) { create(:sensor, user: user1) }
  let(:sensor2) { create(:sensor, user: user2) }
  let(:sensor3) { create(:sensor, user: user3) }

  before do
    advocate1.collaborators << [user1, user2, user3]
    advocate2.collaborators << [user1, user3]
    advocate3.collaborators << [user3]

    reading(user1, sensor1, "2016-12-01 02:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 03:00:00", violation: false)
    reading(user1, sensor1, "2016-12-01 04:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 05:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 06:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 07:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 08:00:00", violation: true)
    reading(user1, sensor1, "2016-12-01 09:00:00", violation: false)
    reading(user1, sensor1, "2016-12-01 10:00:00", violation: true)

    reading(user2, sensor2, "2016-12-01 02:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 03:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 04:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 05:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 06:00:00", violation: false)
    reading(user2, sensor2, "2016-12-01 07:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 08:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 09:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 10:00:00", violation: true)
    reading(user2, sensor2, "2016-12-01 11:00:00", violation: false)

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
    worker = DailyViolationEmailWorker.new(
      start_at: DateTime.parse("2016-12-01 00:00:00"),
      end_at: DateTime.parse("2016-12-02 00:00:00"),
    )
    results = worker.violations_periods_query.to_a

    expect(results.size).to eq 3
    results = results.sort_by { |r| [r['user_id'], r['start_at']] }

    expect(results[0]).to include("user_id" => user1.id.to_s, "duration" => "04:00:00")
    expect(results[1]).to include("user_id" => user2.id.to_s, "duration" => "03:00:00")
    expect(results[2]).to include("user_id" => user2.id.to_s, "duration" => "03:00:00")

    expect(UserMailer).to receive(:violations_report).with(hash_including(recipient: advocate1)) do |args|
      violations = args[:violations]
      expect(violations.size).to eq 3

      expect(violations[0].user).to eq user1
      expect(violations[0].data["duration"]).to eq "04:00:00"
      expect(violations[1].user).to eq user2
      expect(violations[1].data["duration"]).to eq "03:00:00"
      expect(violations[2].user).to eq user2
      expect(violations[2].data["duration"]).to eq "03:00:00"
    end

    expect(UserMailer).to receive(:violations_report).with(hash_including(recipient: advocate2)) do |args|
      violations = args[:violations]
      expect(violations.size).to eq 1

      expect(violations[0].user).to eq user1
      expect(violations[0].data["duration"]).to eq "04:00:00"
    end

    worker.perform
  end

  def reading(user, sensor, time, violation:)
    s = create(:reading, user: user, sensor: sensor, created_at: DateTime.parse(time))
    s.update(violation: violation)
  end
end
