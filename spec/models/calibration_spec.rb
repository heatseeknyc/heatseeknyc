require 'spec_helper'

describe Calibration do
  let!(:sensor1) { FactoryGirl.create(:sensor) }
  let!(:sensor2) { FactoryGirl.create(:sensor) }
  let!(:sensor3) { FactoryGirl.create(:sensor) }
  let!(:sensor4) { FactoryGirl.create(:sensor) }

  let!(:calibration1) { FactoryGirl.create(:calibration, offset: -2, start_at: 2.months.ago, end_at: 2.months.from_now) }
  let!(:calibration2) { FactoryGirl.create(:calibration, offset: 4, start_at: 2.months.ago, end_at: 2.months.from_now) }

  before do
    calibration1.sensors << [sensor1, sensor2]
    calibration2.sensors << [sensor3]
  end

  describe ".apply!" do
    it "applies a relevant calibration" do
      calibration3 = FactoryGirl.create(:calibration, offset: -5, start_at: 16.months.ago, end_at: 12.months.ago)
      calibration3.sensors << sensor1

      reading1 = FactoryGirl.create(:reading, sensor: sensor1, temp: 70, created_at: 14.months.ago)
      reading2 = FactoryGirl.create(:reading, sensor: sensor3, temp: 65)

      Calibration.apply!(reading1)
      expect(reading1.temp).to equal(65)
      expect(reading1.original_temp).to equal(70)

      Calibration.apply!(reading2)
      expect(reading2.temp).to equal(69)
      expect(reading2.original_temp).to equal(65)
    end

    it "does not apply a calibration if there is not one" do
      reading = FactoryGirl.create(:reading, sensor: sensor1, temp: 70, created_at: 14.months.ago)

      Calibration.apply!(reading)
      expect(reading.temp).to equal(70)
      expect(reading.original_temp).to equal(70)
    end
  end

  describe "#apply!" do
    it "raises error if calibration does not apply to sensor" do
      reading = FactoryGirl.create(:reading, sensor: sensor1)
      expect { calibration2.apply!(reading) }.to raise_error(ArgumentError)
    end

    it "raises error if calibration dates do not apply to reading" do
      calibration1.update!(start_at: DateTime.now)
      reading = FactoryGirl.create(:reading, sensor: sensor1, created_at: 1.month.ago)
      expect { calibration1.apply!(reading) }.to raise_error(ArgumentError)
    end

    it "applies calibration to reading" do
      reading = FactoryGirl.create(:reading, sensor: sensor1, temp: 70)
      calibration1.apply!(reading)
      expect(reading.temp).to equal(68)
      expect(reading.original_temp).to equal(70)
    end

    it "updates violation boolean" do
      reading = FactoryGirl.create(:reading, sensor: sensor1, temp: 60, outdoor_temp: 30)
      calibration1.update(offset: -10)

      expect(reading.violation).to equal(false)

      calibration1.apply!(reading)
      reading.reload

      expect(reading.temp).to equal(50)
      expect(reading.original_temp).to equal(60)
      expect(reading.violation).to equal(true)
    end
  end

  describe ".recalibrate!" do
    it "applies calibrations to respective readings" do
      reading1 = FactoryGirl.create(:reading, sensor: sensor1, temp: 70, created_at: 14.months.ago)
      reading2 = FactoryGirl.create(:reading, sensor: sensor1, temp: 71)
      reading3 = FactoryGirl.create(:reading, sensor: sensor3, temp: 64)
      reading4 = FactoryGirl.create(:reading, sensor: sensor4, temp: 60)

      Calibration.recalibrate!(Calibration.all)

      reading1.reload
      expect(reading1.temp).to equal(70)
      expect(reading1.original_temp).to equal(70)

      reading2.reload
      expect(reading2.temp).to equal(69)
      expect(reading2.original_temp).to equal(71)

      reading3.reload
      expect(reading3.temp).to equal(68)
      expect(reading3.original_temp).to equal(64)

      reading4.reload
      expect(reading4.temp).to equal(60)
      expect(reading4.original_temp).to equal(60)
    end
  end
end
