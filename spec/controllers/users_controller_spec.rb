require 'spec_helper'

describe UsersController do
  describe "GET /users/:id/download" do
    let(:pdf_writer) { double('pdf_writer') }
    let(:file) { double('file') }

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(PDFWriter).to receive(:new_from_user_id).with("1").and_return pdf_writer
      allow(pdf_writer).to receive(:generate_pdf).and_return file
      allow(pdf_writer).to receive(:filename)
      allow(pdf_writer).to receive(:content_type)
      allow(controller).to receive(:send_data).
                              with(file, filename: pdf_writer.filename, type: pdf_writer.content_type).
                              and_return{controller.render :nothing => true}
    end

    it "instantiates a pdf writer" do
      expect(PDFWriter).to receive(:new_from_user_id).with("1").and_return pdf_writer
      get :download_pdf, id: 1
    end

    it "sends the data" do
      expect(controller).to receive(:send_data).
                              with(file, filename: pdf_writer.filename, type: pdf_writer.content_type).
                              and_return{controller.render :nothing => true}
      get :download_pdf, id: 1                            
    end
  end
end