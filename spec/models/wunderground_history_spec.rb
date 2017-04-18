require "spec_helper"

describe WundergroundHistory, :vcr do
  let(:wunderground) { Wunderground.new }
  let(:time) { Time.zone.parse("January 1, 2000 at 12am") }
  let(:response) { wunderground.history_for(time, "knyc") }

  describe "error handling" do

    describe "validate!" do
      context "when history is empty" do
        let(:out_of_range_time) { Time.zone.parse("January 1, 3000 at 12am") }
        let(:empty_response) do
          wunderground.history_for(out_of_range_time, "knyc")
        end
        let(:empty_history) do
          build(:wunderground_history, {
            time: out_of_range_time,
            response: empty_response
          })
        end

        it "adds 'response is empty' error" do
          invalid_time_message = {response: ["response is empty"]}
          empty_history.validate!

          expect(empty_history.errors.get(:response).size).to eq(1)
          expect(empty_history.errors.messages).to eq(invalid_time_message)
        end
      end

      xit "adds error when rate limited" do
        subject.time = time
        subject.response = response
        subject.validate!
        expect(subject).to be_rate_limited # only re-record while rate-limited
      end

      it "adds error when location is invalid" do
        subject.time = time
        subject.response = wunderground.history_for(time, "1001101")
        subject.validate!
        expect(subject.response_error_type).to eq "querynotfound"
        expect(subject.errors.get(:response).size).to eq(1)
      end
    end

    describe "missing_target_hour?" do
      it "returns true when no data yet available from wunderground" do
        time = Time.zone.parse("January 1, 3000 at 12am")
        subject.time = time
        subject.response = wunderground.history_for(time, "knyc")
        expect(subject).to be_missing_target_hour
      end

      it "returns false when data was available at time of creation" do
        subject.time = time
        subject.response = wunderground.history_for(time, "knyc")
        expect(subject).to_not be_missing_target_hour
      end

      it "returns works when a time with a different timezone is passed in" do
        subject.time = time.utc
        subject.response = wunderground.history_for(time, "knyc")
        expect(subject).to_not be_missing_target_hour
      end
    end

    describe "empty?" do
      it "returns true when no data yet available from wunderground" do
        time = Time.zone.parse("January 1, 3000 at 12am")
        subject.time = time
        subject.response = wunderground.history_for(time, "knyc")
        expect(subject).to be_empty
      end

      it "returns false when data was available at time of creation" do
        subject.time = time
        subject.response = wunderground.history_for(time, "knyc")
        expect(subject).to_not be_empty
      end
    end

    describe "rate_limited?" do
      before(:each) do
        subject.time = time
        subject.response = wunderground.history_for(time, "knyc")
      end

      xit "returns true when rate limited" do
        expect(subject).to be_rate_limited # only re-record while rate-limited
      end

      it "returns false when not rate limited" do
        expect(subject).to_not be_rate_limited
      end
    end
  end

  describe "populate_observations" do
    it "attaches a collection of observations with an hour and a temperature" do
      subject.time = time
      subject.response = response
      expect(subject.observations).to be_nil
      subject.populate_observations
      observation = subject.observations.first
      expect(observation.hour).to eq 0
      expect(observation.temperature).to eq 37.9
    end
  end

  describe ".new_from_api" do
    it "returns a WundergroundHistory object that has a temperature" do
      response = wunderground.history_for(time, "knyc")
      return_object = WundergroundHistory.new_from_api(time,response)
      expect(return_object.temperature).to eq 37.9
    end

    # don't make this one a Wunderground::Error, it's from us
    it "raises errors if data requested prematurely" do
      time = Time.zone.parse("January 23, 2016 at 6pm")
      premature_response = wunderground.history_for(time, 10001)
      history = WundergroundHistory.new_from_api(time, premature_response)

      expected_message = "response is missing desired hour"
      expect(history.errors.get(:response).size).to eq(1)
      expect(history.errors.messages[:response]).to include(expected_message)
    end

    # make this one a Wunderground::Error
    xit "raises errors if rate limited" do
      time = Time.zone.parse("March 1, 2015 at 12am")
      rate_limited_response = wunderground.history_for(time, 10001)
      history = WundergroundHistory.new_from_api(time, rate_limited_response)

      expect(history.error_on(:response).size).to eq(1)
      expect(history.response_error_type).to eq "invalidfeature"
    end
  end

  describe "#temperature" do
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
