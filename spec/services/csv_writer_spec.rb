require 'spec_helper'
require 'csv_writer'

describe CSVWriter do
  let(:user) { create(:user) }
  let(:writer) { CSVWriter.new(user.id) }

  describe "#generate_csv" do
    it "generates a csv for a user with readings" do
      reading1 = create(:reading, user: user)
      reading2 = create(:reading, :violation, user: user)
      generated_csv = writer.generate_csv
      time = "%l:%M%p"
      date = "%m/%d/%Y"
      expect(generated_csv).to include("TIME,DATE,TEMP INSIDE,TEMP OUTSIDE,TEMP OF HOT WATER,NOTES")
      expect(generated_csv).to include("#{reading1.created_at.strftime(time)},#{reading1.created_at.strftime(date)},#{reading1.temp},#{reading1.outdoor_temp},,")
      expect(generated_csv).to include("#{reading2.created_at.strftime(time)},#{reading2.created_at.strftime(date)},#{reading2.temp},#{reading2.outdoor_temp},,violation")
    end

    it "returns a filename" do
      expect(writer.filename).to eq("#{user.last_name}.csv")
    end

    it "generates a csv for a user without readings" do
      generated_csv = writer.generate_csv
      expect(generated_csv).to include("TIME,DATE,TEMP INSIDE,TEMP OUTSIDE,TEMP OF HOT WATER,NOTES")
    end
  end
end