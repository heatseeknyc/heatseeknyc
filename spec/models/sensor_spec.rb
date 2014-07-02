require 'spec_helper'

describe Sensor do
  context '#user' do
    it "returns the user assigned to the sensor" do
      tom = create(:user)
      subject.user = tom
      expect(subject.user).to eq tom
    end
  end

  context '#name' do
    it "has a name" do
      subject.name = "Tahiti"
      expect(subject.name).to eq "Tahiti"
    end
  end
end
