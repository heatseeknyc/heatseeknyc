require 'spec_helper'

describe Regulator do
  describe "#self.in_violation?" do
    context "during the day" do

      before(:each) do
        Timecop.travel(Time.zone.parse('March 1, 2015 12:00:00 -0400'))
      end

      after(:each) do
        Timecop.travel(Time.zone.parse('March 1, 2015 00:00:00 -0400'))
      end

      it "returns violation status of a single reading" do
        reading = create(:reading, temp: 67, outdoor_temp: 54)
        regulator = Regulator.new(reading)
        expect(regulator).to have_detected_violation
        reading.outdoor_temp = 55
        expect(regulator).to_not have_detected_violation
        reading.outdoor_temp = 54
        reading.temp = 68
        expect(regulator).to_not have_detected_violation
        reading.outdoor_temp = 55
        expect(regulator).to_not have_detected_violation
      end

      it "returns violation status of multiple readings" do
        reading1 = create(:reading, temp: 67, outdoor_temp: 54)
        reading2 = create(:reading, temp: 68, outdoor_temp: 54)
        readings = [reading1, reading2]

        regulator = Regulator.new(readings)
        expect(regulator).to have_detected_violation
        reading1.outdoor_temp = 70
        expect(regulator).to_not have_detected_violation
      end
    end

    context "during the night" do

      before(:each) do
        Timecop.travel(Time.zone.parse('March 1, 2015 05:00:00 -0400'))
      end

      after(:each) do
        Timecop.travel(Time.zone.parse('March 1, 2015 00:00:00 -0400'))
      end

      it "returns violation status of a single reading" do
        reading = create(:reading, temp: 54, outdoor_temp: 39)
        regulator = Regulator.new(reading)
        expect(regulator).to have_detected_violation
        reading.outdoor_temp = 40
        expect(regulator).to_not have_detected_violation
        reading.outdoor_temp = 39
        reading.temp = 55
        expect(regulator).to_not have_detected_violation
        reading.outdoor_temp = 40
        expect(regulator).to_not have_detected_violation
      end

      it "returns violation status of multiple readings" do
        reading1 = create(:reading, temp: 54, outdoor_temp: 39)
        reading2 = create(:reading, temp: 55, outdoor_temp: 39)
        readings = [reading1, reading2]

        regulator = Regulator.new(readings)
        expect(regulator).to have_detected_violation
        reading1.outdoor_temp = 65
        expect(regulator).to_not have_detected_violation
      end
    end
  end

  describe "#inspect!" do
    context "when in violation" do
      before do
        ActiveRecord::Base.transaction do
          10.times { create(:reading, :day_time, { temp: 75, outdoor_temp: 50 }) }
        end
      end

      it "updates violation status to true", :vcr do
        expect(Reading.where(violation: true)).to have(0).items

        Reading.first.update(temp: 65)
        Regulator.new(Reading.all).inspect!
        expect(Reading.where(violation: true)).to have(1).item
      end
    end

    context "when not in violation" do
      before do
        ActiveRecord::Base.transaction do
          10.times { create(:reading, :day_time, { temp: 65, outdoor_temp: 50 }) }
        end
      end

      it "updates violation status to false", :vcr do
        expect(Reading.where(violation: true)).to have(10).items

        Reading.update_all(outdoor_temp: 60)
        Regulator.new(Reading.all).inspect!
        expect(Reading.where(violation: true)).to be_empty
      end
    end
  end

  describe "#batch_inspect!" do
    context "with a few records" do
      before do
        ActiveRecord::Base.transaction do
          10.times { create(:reading, :day_time, {temp: 75, outdoor_temp: 50 }) }
        end
      end

      it "updates violation status in batches", :vcr do
        expect(Reading.where(violation: true)).to have(0).items

        Reading.order(created_at: :asc).first.update(temp: 65)
        Reading.order(created_at: :asc).last.update(temp: 65)

        Regulator.new(Reading.all).batch_inspect!(silent: true)
        expect(Reading.where(violation: true)).to have(2).items
      end
    end

    context "with many records" do
      # Extract this into a less frequently run test suite
      # it's too slow to run before each deployment
      before do
        i = 0
        100.times do
          ActiveRecord::Base.transaction do
            puts i += 1
            100.times do
              create(:reading, :day_time, {
                temp: 75,
                outdoor_temp: 50
              })
            end
          end
        end
      end

      xit "updates violation status in batches", :vcr do
        expect(Reading.where(violation: true)).to have(0).items

        Reading.order(created_at: :asc).first.update(temp: 65)
        Reading.order(created_at: :asc).last.update(temp: 65)

        Regulator.new(Reading.all).batch_inspect!
        expect(Reading.where(violation: true)).to have(2).items
      end
    end
  end
end
