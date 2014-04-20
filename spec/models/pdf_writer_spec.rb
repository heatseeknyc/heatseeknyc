require 'spec_helper'

describe PDFWriter do
  describe "#generate_pdf" do
    it "generates a pdf" do
      user = create(:user)
      user.readings << create(:reading)
      writer = PDFWriter.new_from_user_id(user.id)
      expect(writer.generate_pdf).to be_an_instance_of(String)
    end
  end
end
