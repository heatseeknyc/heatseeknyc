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

  describe "GET /users/edit_password" do
    context "user is logged in" do
      before { sign_in create(:user) }

      it "renders the edit_password form" do
        get :edit_password
        expect(response).to be_ok
        expect(response).to render_template("edit_password")
      end
    end

    context "user is not logged in" do
      it "redirects to sign in form" do
        get :edit_password
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /users/update_password" do
    context "user is logged in" do
      let(:user) { create(:user) }
      let(:new_pass) { "new_password" }
      let(:password_params) do
        { current_password: user.password,
          password: new_pass,
          password_confirmation: new_pass }
      end

      before { sign_in user }

      it "redirects to root on update success" do
        patch :update_password, user: password_params
        expect(response).to redirect_to(root_path)
      end

      it "re-renders the edit form on update failure" do
        password_params[:current_password] = "bad password"
        patch :update_password, user: password_params
        expect(response.status).to eq(401)
        expect(response).to render_template("edit_password")
      end
    end

    context "user is not logged in" do
      it "redirects to sign in form" do
        patch :update_password
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end