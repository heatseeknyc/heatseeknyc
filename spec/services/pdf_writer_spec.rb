require 'spec_helper'
require 'pdf_writer'

describe PDFWriter do
  let(:user) { create(:user) }

  describe "#generate_pdf" do
    it "generates a pdf for a user with readings" do
      create(:reading, user: user)
      writer = PDFWriter.new_from_user_id(user.id)
      expect(writer.generate_pdf).to be_an_instance_of(String)
    end

    it "generates a pdf for a user with no readings" do
      writer = PDFWriter.new_from_user_id(user.id)
      expect(writer.generate_pdf).to be_an_instance_of(String)
    end

    it "generates a cover page" do
      begin_date = DateTime.parse("2015-02-20 13:00:00 #{Time.now.getlocal.zone}")
      end_date = begin_date + 5.days
      create(:reading, :violation, user: user, created_at: begin_date)
      create(:reading, :violation, user: user, created_at: begin_date + 1.day)
      create(:reading, user: user, created_at: begin_date + 3.days)
      create(:reading, user: user, created_at: end_date)

      writer = PDFWriter.new_from_user_id(user.id)
      rendered_pdf = writer.generate_pdf
      pdf_analysis = PDF::Inspector::Text.analyze(rendered_pdf)

      expect(pdf_analysis.strings).to include("Tenant: #{user.name}")
      expect(pdf_analysis.strings).to include("Address: #{user.address}, Unit #{user.apartment}, #{user.zip_code}")
      expect(pdf_analysis.strings).to include("Phone Number: #{user.phone_number}")
      expect(pdf_analysis.strings).to include("Begin: Feb 20, 2015 1:00 PM")
      expect(pdf_analysis.strings).to include("End: Feb 25, 2015 1:00 PM")
      expect(pdf_analysis.strings).to include("Total Temperature Readings: 4")
      expect(pdf_analysis.strings).to include("Total Violations: 2")
      expect(pdf_analysis.strings).to include("Percentage: 50.0%")
    end
  end
end
