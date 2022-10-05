require "spec_helper"

describe Admin::BuildingsController, type: :controller do

  let(:team_member) { create(:user, permissions: User::PERMISSIONS[:team_member]) }

  before :each do
    sign_in team_member
  end

  describe "#create" do
    let(:building) { FactoryBot.build(:building) }

    it "updates geocode on create" do
      post :create, params: { building: building.attributes }

      expect(WebMock).to have_requested(:get, /maps\.googleapis\.com/).twice
    end

    it "redirects to buildings index" do
      post :create, params: { building: building.attributes }

      expect(response).to redirect_to(admin_buildings_path)
    end
  end

  describe "#update" do
    let(:building) { FactoryBot.create(:building) }

    it "updates geocode if relevant fields changed" do
      put :update, params: { id: building.id, building: building.attributes.merge(zip_code: "10001") }

      expect(WebMock).to have_requested(:get, /maps\.googleapis\.com/).twice
    end

    it "redirects to buildings index" do
      put :update, params: { id: building.id, building: building.attributes.merge(zip_code: "10001") }

      expect(response).to redirect_to(admin_buildings_path)
    end
  end
end
