require 'spec_helper'
require 'pdf_writer'

describe PDFWriter do
  let(:user) { create(:user) }

  describe "#generate_pdf" do
    it "generates a pdf for a user with readings" do
      create(:reading, user: user, created_at: DateTime.new(2015, 12, 1))
      writer = PDFWriter.new_from_user_id(user.id, years: [2015, 2016])
      expect(writer.generate_pdf).to be_an_instance_of(String)
    end

    it "generates a pdf for a user with no readings" do
      writer = PDFWriter.new_from_user_id(user.id, years: [2015, 2016])
      expect(writer.generate_pdf).to be_an_instance_of(String)
    end

    it "generates a cover page" do
      begin_date = DateTime.new(2015, 12, 1).change(hour: 15) - 5.days
      first_reading = create(:reading, :violation, user: user, created_at: begin_date)
      create(:reading, :violation, user: user, created_at: begin_date + 1.day)
      create(:reading, user: user, created_at: begin_date + 3.days)
      last_reading = create(:reading, user: user, created_at: begin_date + 5.days)

      excluded_reading = create(:reading, user: user, created_at: DateTime.new(2017, 11, 1))

      writer = PDFWriter.new_from_user_id(user.id, years: [2015, 2016])
      rendered_pdf = writer.generate_pdf
      pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

      expect(pdf_analysis.strings).to include("Tenant: #{user.name}")
      expect(pdf_analysis.strings).to include("Address: #{user.address}, Unit #{user.apartment}, #{user.zip_code}")
      expect(pdf_analysis.strings).to include("Phone Number: #{user.phone_number}")
      expect(pdf_analysis.strings).to include("Begin: #{first_reading.created_at.strftime("%b %d, %Y%l:%M %p")}")
      expect(pdf_analysis.strings).to include("End: #{last_reading.created_at.strftime("%b %d, %Y%l:%M %p")}")
      expect(pdf_analysis.strings).to include("Total Temperature Readings: 4")
      expect(pdf_analysis.strings).to include("Total Violations: 2")
      expect(pdf_analysis.strings).to include("Percentage: 50.0%")
    end
  end
end
