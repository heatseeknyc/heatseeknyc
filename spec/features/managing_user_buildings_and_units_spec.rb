require "spec_helper"

feature "Assigning buildings and units to users" do
  let(:building) { create(:building) }
  let!(:unit) { create(:unit, building: building) }
  let!(:tenant) { create(:user) }

  # before { login_as_team_member }

  before do
    team_member = create(:team_member)
    login_as(team_member)
  end

  scenario "Setting a building and unit from the user edit form", js: true do
    visit edit_user_path(tenant)

    find("#user_building_id").select(building.street_and_zip)
    find("#user_unit_id").select(unit.name.upcase)

    click_button("SAVE")

    expect(tenant.building_id).to eq(building.id)
    expect(tenant.unit_id).to eq(unit.id)
  end
end
