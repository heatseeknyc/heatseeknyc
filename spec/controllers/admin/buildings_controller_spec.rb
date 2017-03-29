require "spec_helper"

describe Admin::BuildingsController, type: :controller do

  let(:team_member) { create(:user, permissions: User::PERMISSIONS[:team_member]) }

  before :each do
    sign_in team_member
  end

  describe "#create" do
    let(:building) { FactoryGirl.build(:building) }

    it "updates geocode on create" do
      post :create, { building: building.attributes }

      expect(WebMock).to have_requested(:get, /maps\.googleapis\.com/).twice
    end
  end

  describe "#update" do
    let(:building) { FactoryGirl.create(:building) }

    it "updates geocode if relevant fields changed" do
      put :update, { id: building.id, building: building.attributes.merge(zip_code: "10001") }

      expect(WebMock).to have_requested(:get, /maps\.googleapis\.com/).twice
    end

    it "does not update geocode if relevant fields not changed" do
      put :update, { id: building.id, building: building.attributes }

      expect(WebMock).to_not have_requested(:get, /maps\.googleapis\.com/)
    end
  end
end
