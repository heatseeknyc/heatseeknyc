require 'spec_helper'

describe OutdoorTempPopulator do
  describe "populate" do

    let(:pending_reading) do
      create(:reading, {
      }) 
    end

    let(:resolved_reading) { create(:reading, :resolved) }

    before { allow(WeatherService).to receive(:history_for).with(zip, range) }

    it "populates readings pending outdoor temp" do
      expect(Reading.pending_outdoor_temp).to include pending_reading
      subject.populate
      expect(Reading.pending_outdoor_temp).to_not include pending_reading
    end

    # pending:
    #
    #   4/2015, 3, 55555
    #   2/2015, 2, 55555
    #
    # 5 pending readings
    #   max date of pending readings: 4/2015
    #   get history for 4/2015 and use that to populate pending readings
    #
    # when history covers 4/2015
    #
    # pending = [...]
    # max_pending = pending.max(&:date)
    # min_pending = pending.min(&:date)
    # history = []
    #
    # # get history all readings pending outdoor temp
    # history_for(max_pending)
    #   history << weather_service.results
    #   min_date = history.min(&:date)
    #   if min_date > min_pending
    #     history_for(zip, min_date)
    #   end
    # end
    #

    it "attempts to get weather for pending readings"
    it "does not request duplicate time-zipcode combinations"
  end
end
