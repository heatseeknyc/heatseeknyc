require 'spec_helper'

describe WundergroundHistory, :vcr do
  let(:wunderground) { Wunderground.new(ENV['WUNDERGROUND_KEY']) }

  describe "error handling" do
    let(:time) { Time.zone.parse('January 1, 2000 at 12am') }
    let(:response) { wunderground.history_for(time, 'knyc') }
    let(:out_of_range_time) { Time.zone.parse('January 1, 3000 at 12am') }

    describe "validate!" do
      context "when history is empty" do
        let(:empty_response) { wunderground.history_for(out_of_range_time, 'knyc') }
        let(:empty_history) do
          build(:wunderground_history, {
            time: out_of_range_time,
            response: empty_response
          })
        end

        it "adds 'response is empty' error" do
          invalid_time_message = {response: ["response is empty"]}
          empty_history.validate!

          expect(empty_history.errors).to have(1).errors_on(:response)
          expect(empty_history.errors.messages).to eq(invalid_time_message)
        end
      end

      it "adds error when rate limited" do
        subject.time = time
        subject.response = response
        subject.validate!
        expect(subject).to be_rate_limited # only re-record while rate-limited
      end

      it "adds error when location is invalid" do
        subject.time = Time.zone.parse('January 1, 2000 at 12am')
        subject.response = wunderground.history_for(subject.time, '1001101')
        subject.validate!
        expect(subject.response_error_type).to eq 'querynotfound'
        expect(subject.errors).to have(1).errors_on(:response)
      end
    end

    describe "missing_target_hour?" do
      it "returns true when no data yet available from wunderground" do
        subject.time = Time.zone.parse('January 1, 3000 at 12am')
        subject.response = wunderground.history_for(subject.time, 'knyc')
        expect(subject).to be_missing_target_hour
      end

      it "returns false when data was available at time of creation" do
        subject.time = Time.zone.parse('January 1, 2000 at 12am')
        subject.response = wunderground.history_for(subject.time, 'knyc')
        expect(subject).to_not be_missing_target_hour
      end
    end

    describe "empty?" do
      it "returns true when no data yet available from wunderground" do
        subject.time = Time.zone.parse('January 1, 3000 at 12am')
        subject.response = wunderground.history_for(subject.time, 'knyc')
        expect(subject).to be_empty
      end

      it "returns false when data was available at time of creation" do
        subject.time = Time.zone.parse('January 1, 2000 at 12am')
        subject.response = wunderground.history_for(subject.time, 'knyc')
        expect(subject).to_not be_empty
      end
    end

    describe "rate_limited?" do
      before(:each) do
        subject.time = Time.zone.parse('January 1, 2000 at 12am')
        subject.response = wunderground.history_for(subject.time, 'knyc')
      end

      it "returns true when rate limited" do
        expect(subject).to be_rate_limited # only re-record while rate-limited
      end

      it "returns false when not rate limited" do
        expect(subject).to_not be_rate_limited
      end
    end
  end

  describe "populate_observations!" do
    it "stores an ObservationCollection object to observations attribute" do
      wh.time = Time.zone.parse('January 1, 2000 00:00:00 -04:00')
      wh.response = wunderground.history_for(wh.time, 'knyc')
      expect(wh.observations).to be_nil
      wh.populate_observations!
      expect(wh.observations).to be_a ObservationCollection
    end
  end

  describe ".new_from_api" do
    it "returns a WundergroundHistory object" do
      time = Time.zone.parse('January 1, 2000 00:00:00 -04:00')
      response = wunderground.history_for(time, 'knyc')
      return_object = WundergroundHistory.new_from_api(time,response)
      expect(return_object).to be_a WundergroundHistory
    end

    # don't make this one a Wunderground::Error, it's from us
    it "raises errors if data requested prematurely" do
      time = Time.zone.parse('January 23, 2016 at 6pm')
      premature_response = wunderground.history_for(time, 10001)
      history = WundergroundHistory.new_from_api(time, premature_response)

      expected_message = 'response is missing desired hour'
      expect(history.errors).to have(1).error_on(:response)
      expect(history.errors.messages[:response]).to include(expected_message)
    end

    # make this one a Wunderground::Error
    it 'raises errors if rate limited' do
      time = Time.zone.parse('March 1, 2015 at 12am')
      rate_limited_response = wunderground.history_for(time, 10001)
      history = WundergroundHistory.new_from_api(time, rate_limited_response)

      expect(history.errors).to have(1).error_on(:response)
      expect(history.response_error_type).to eq 'invalidfeature'
    end
  end

  describe '#temperature' do
    context "when observation for given time is present" do
      it "returns the temperature" do
        wunderground_history = build(:wunderground_history, :full_day)
        expect(wunderground_history).to be_a WundergroundHistory
        expect(wunderground_history.temperature).to eq 39
      end
    end

    context "when observation for given time is missing" do
      it "returns nil" do
        wunderground_history = build(:wunderground_history)
        expect(wunderground_history).to be_a WundergroundHistory
        expect(wunderground_history.temperature).to eq nil
      end
    end
  end
end
