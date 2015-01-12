require 'spec_helper'

describe Twine do
  let(:twine) { create(:twine) }
  let(:user) { twine.user }
  
  it "has readings" do
    reading1 = create(:reading, twine: twine)
    reading2 = create(:reading, twine: twine)
    expect(twine.readings.count).to eq 2
  end
end
