require "spec_helper"

feature "Assigning buildings and units to users on the admin create/edit user form" do
  let(:building) { create(:building) }
  let!(:unit) { create(:unit, building: building) }
  let!(:tenant) { create(:user) }

  before { login_as_team_member }

  scenario "Setting a building and unit from the user edit form" do
    visit edit_user_path(tenant)
    find("#user_unit_id").select(unit.display_name_with_building)

    click_button("SAVE")

    expect(tenant.reload.unit_id).to eq(unit.id)
    expect(tenant.building.id).to eq(building.id)
  end
end