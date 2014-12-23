require 'spec_helper'

describe Twine do
  
  it "has readings" do
    twine1 = create(:twine)
    reading1 = create(:reading, twine: twine1)
    reading2 = create(:reading, twine: twine1)
    expect(twine1.readings.count).to eq 2
  end

  describe "#get_reading" do
    it "scrapes reading from twine.cc" do
      expect(Reading.count).to eql 0
      ENV["WUNDERGROUND_API_KEY"] = 'd48122149ff66bca'
      twine = Twine.create(user: create(:user), name: 'sandbox', email: 'fake@gmail.com')
      VCR.use_cassette('wunderground') do
        reading = twine.get_reading
      end
      expect(Reading.count).to eql 1
      expect(Reading.first.temp).to_not eql nil
      expect(Reading.first.outdoor_temp).to_not eql nil
      expect(Reading.first.twine_id).to eql twine.id
    end
  end
  #   it "makes a new reading" do
  #     twine_with_reading = create(:twine, email: "wm.jeffries+1@gmail.com")
  #     reading1 = twine_with_reading.get_reading
  #     expect(twine_with_reading.readings.first).to eq reading1
  #   end

  #   it "assigns readings to correct user" do
  #     twine1 = create(:twine)
  #     reading = twine1.get_reading
  #     expect(reading.user).to eq twine1.user
  #   end
  # end
end
