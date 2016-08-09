require "spec_helper"

feature "Unit management is restricted to admin users" do
  scenario "Denies access to a non-admin user" do
    building = create(:building)
    unit = building.units.create(name: "1A", floor: 1)

    login_as_tenant

    visit "/admin/buildings/#{building.id}/units"
    expect(current_path).to eq(root_path)

    visit "/admin/buildings/#{building.id}/units/new"
    expect(current_path).to eq(root_path)

    # visit "/admin/buildings/#{building.id}/units/#{unit.id}/edit"
    # expect(current_path).to eq(root_path)
  end
end

feature "Unit management" do
  let(:building) { create(:building) }
  let(:building_units_path) { "/admin/buildings/#{building.id}/units/" }

  before { login_as_team_member }

  scenario "Viewing index" do
    unit = building.units.create(name: "1A", floor: 1)
    visit building_units_path

    expect(page).to have_content(unit.name)
    expect(page).to have_content(unit.floor)
  end

  scenario "Creating a new unit" do
    visit building_units_path
    click_button "CREATE NEW UNIT"

    fill_in "Name", with: "2A"
    fill_in "Floor", with: 2
    fill_in "Description", with: "A cozy and charming (overpriced) loft."

    click_button "CREATE"

    expect(current_path).to eq(admin_building_unit_path(building))
    expect(page).to have_content("Successfully created.")
    expect(page).to have_content(building.units.last.name)
  end
end
