require 'spec_helper'

describe Twine do
  
  xit "has readings" do
    twine1 = create(:twine)
    reading1 = create(:reading, twine: twine1)
    reading2 = create(:reading, twine: twine1)
    expect(twine1.readings.count).to eq 2
  end

  describe "#get_reading" do
    xit "makes a new reading" do
      twine_with_reading = create(:twine, email: "wm.jeffries+1@gmail.com")
      reading1 = twine_with_reading.get_reading
      expect(twine_with_reading.readings.first).to eq reading1
    end

    xit "assigns readings to correct user" do
      twine1 = create(:twine)
      reading = twine1.get_reading
      expect(reading.user).to eq twine1.user
    end
  end
end
