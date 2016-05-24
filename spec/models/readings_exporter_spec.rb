require "spec_helper"

describe ReadingsExporter do
  let(:user) { create(:user) }
  let!(:reading_1) do
    create(:reading, temp: 50, created_at: 1.week.ago, user: user)
  end
  let!(:reading_2) do
    create(:reading, temp: 55, created_at: 3.days.ago, user: user)
  end
  let!(:reading_3) do
    create(:reading, temp: 60, created_at: 1.day.ago, user: user)
  end

  it "transforms readings into a csv format" do
    exporter = ReadingsExporter.new
    csv = exporter.to_csv
    expect(csv.lines.count).to eq(4)
  end

  describe "building a collection of readings" do
    it "filters by Reading attributes" do
      exporter = ReadingsExporter.new(filter: { user_id: user.id,
                                                temp: reading_1.temp })
      expect(exporter.collection).to eq([reading_1])
    end

    it "filters by a start time" do
      exporter = ReadingsExporter.new(start_time: 4.days.ago)
      expect(exporter.collection).to eq([reading_2, reading_3])
    end

    it "filters by an end time" do
      exporter = ReadingsExporter.new(start_time: 6.days.ago)
      expect(exporter.collection).to eq([reading_2, reading_3])
    end

    it "filters by a time range" do
      exporter = ReadingsExporter.new(start_time: 8.days.ago,
                                      end_time: 6.days.ago)
      expect(exporter.collection).to eq([reading_1])
    end
  end
end
