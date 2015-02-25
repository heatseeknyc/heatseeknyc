require 'spec_helper'

describe QualityControl do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @sensor = @user.sensors.create(name: '1234abcd')
  end

  describe "#self.dedupe" do
    it "dedupes a users's readings" do
      10.times do
        Reading.create({
          sensor: @sensor,
          user: @user,
          temp: 45,
          outdoor_temp: 20,
          created_at: Time.now.to_i
        })
      end

      expect(@user.readings.count).to eq 10
      QualityControl.dedupe(@user)
      expect(@user.readings.count).to eq 1
    end
  end

  describe "#self.truncate_user_until" do
    it "removes readings from a user before a given date" do
      48.times do |i|
        FactoryGirl.create(:reading, {
          user: @user,
          sensor: @sensor,
          created_at: i.hours.ago
        })
      end

      expect(@user.readings.count).to eq 48
      QualityControl.truncate_user_until(@user, 1.day.ago)
      expect(@user.readings.count).to eq 24
    end
  end
end
