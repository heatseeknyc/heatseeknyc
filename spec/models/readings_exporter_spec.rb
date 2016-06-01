require "spec_helper"

describe ReadingsExporter do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:user_3) { create(:user) }
  let!(:reading_1) do
    create(:reading, temp: 50, created_at: 1.week.ago, user: user_1)
  end
  let!(:reading_2) do
    create(:reading, temp: 55, created_at: 3.days.ago, user: user_2)
  end
  let!(:reading_3) do
    create(:reading, temp: 60, created_at: 1.day.ago, user: user_3)
  end

  it "transforms readings into a csv format" do
    exporter = ReadingsExporter.new
    csv = exporter.to_csv
    expect(csv.lines.count).to eq(4)
    expect(CSV.parse(csv, headers: true).first.to_s.chomp).to eq(
      [reading_1.created_at,
       reading_1.temp,
       reading_1.outdoor_temp,
       reading_1.violation,
       reading_1.sensor_id,
       reading_1.user.address,
       reading_1.user.zip_code
      ].join(",")
    )
  end

  it "can export invalid readings without an associated user" do
    reading = create(:reading)
    reading.update_column(:user_id, nil)
    exporter = ReadingsExporter.new(filter: { user_id: nil })
    expect(exporter.to_csv.lines.count).to eq(2)
  end

  describe "building a collection of readings" do
    it "filters by multiple attributes on the Reading model" do
      exporter = ReadingsExporter.new(filter: { user_id: user_1.id,
                                                temp: reading_1.temp })
      expect(exporter.collection).to eq([reading_1])
    end

    it "filters by a collection of user ids" do
      exporter = ReadingsExporter.new(filter: { user_id: [user_1.id,
                                                          user_2.id] })
      expect(exporter.collection).to eq([reading_1, reading_2])
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
