require 'spec_helper'

describe "sensors not reporting spec", type: :feature do
  let!(:user) { login_as_admin }

  before do
    create_sensor("A001", 5.minutes.ago)
    create_sensor("A002", 5.hours.ago)
    create_sensor("A003", 7.hours.ago)
    create_sensor("A004", 10.hours.ago)
    create_sensor("A005", 5.months.ago)

    create_sensor("A006", 7.months.ago)

    create_sensor("A007", 1.month.ago).update(user: nil)
    create_sensor("A008", 3.months.ago)
    reassign_sensor("A008")

    visit not_reporting_sensors_path
  end

  it "it shows sensors which have not reported in the last 6 hours" do
    expect(page).to_not have_text "A001"
    expect(page).to_not have_text "A002"

    expect(page).to have_text "A003"
    expect(page).to have_text "A004"
    expect(page).to have_text "A005"
  end

  it "excludes sensors that have not reported in over 6 months" do
    expect(page).to_not have_text "A006"
  end

  it "excludes sensors not associated with a user" do
    expect(page).to_not have_text "A007"
  end

  it "excludes readings not associated with its current owner user" do
    expect(page).to_not have_text "A008"
  end

  def create_sensor(nick_name, time)
    user = FactoryBot.create(:user)
    sensor = FactoryBot.create(:sensor, :with_user, nick_name: nick_name, user: user)
    sensor.readings << FactoryBot.create(:reading, created_at: time, user: user)
    sensor
  end

  def reassign_sensor(nick_name)
    sensor = Sensor.find_by(nick_name: nick_name)
    user = FactoryBot.create(:user)
    sensor.update(user: user)
    sensor
  end
end
