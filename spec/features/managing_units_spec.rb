require "spec_helper"

feature "Unit management is restricted to admin users" do
  scenario "Denies access to a non-admin user" do
    building = create(:building)
    unit = create(:unit, building: building)

    login_as_tenant

    visit "/admin/buildings/#{building.id}/units"
    expect(current_path).to eq(root_path)

    visit "/admin/buildings/#{building.id}/units/new"
    expect(current_path).to eq(root_path)

    visit "/admin/buildings/#{building.id}/units/#{unit.id}/edit"
    expect(current_path).to eq(root_path)
  end
end

feature "Unit management" do
  let(:building) { create(:building) }
  let(:existing_unit) { create(:unit, building: building) }

  before { login_as_team_member }

  scenario "Viewing index" do
    existing_unit
    visit admin_building_units_path(building)

    expect(page).to have_content(existing_unit.name.upcase)
    expect(page).to have_content(existing_unit.floor)
  end

  scenario "Creating a new unit" do
    visit admin_building_units_path(building)
    click_link "Create New Unit"

    fill_in "Name", with: "2A"
    fill_in "Floor", with: 2
    fill_in "Description", with: "A cozy and charming (overpriced) loft."

    click_button "CREATE"

    expect(current_path).to eq(admin_building_units_path(building))
    expect(page).to have_content("Successfully created.")
    expect(page).to have_content(building.units.last.name.upcase)
  end

  scenario "Creating a new unit displays validation errors" do
    visit admin_building_units_path(building)
    click_link "Create New Unit"

    fill_in "Floor", with: 1
    click_button "CREATE"

    expect(page).to have_content("Save failed due to errors.")
    expect(page).to have_content("can't be blank")
  end

  scenario "Updating an existing unit" do
    visit edit_admin_building_unit_path(building, existing_unit)

    expect(find_field("Name").value).to eq(existing_unit.name)
    expect(find_field("Floor").value).to eq(existing_unit.floor)
    expect(find_field("Description").value).to eq(existing_unit.description.to_s)

    fill_in "Name", with: "5B"
    fill_in "Floor", with: 4
    fill_in "Description", with: "This is different"

    click_button "UPDATE"

    expect(current_path).to eq(admin_building_units_path(building))
    expect(page).to have_content("Successfully updated.")
    expect(page).to have_content("5B")
    expect(page).to have_content("4")
    expect(page).to have_content("This is different")
  end

  scenario "Updating a unit displays validation errors" do
    visit edit_admin_building_unit_path(building, existing_unit)

    fill_in "Name", with: ""

    click_button "UPDATE"

    expect(current_path).to eq(admin_building_unit_path(building, existing_unit))
    expect(page).to have_content("Save failed due to errors.")
    expect(page).to have_content("can't be blank")
  end

  scenario "Deleting a unit" do
    visit admin_building_units_path(existing_unit.building)

    within(:css, "li#unit-#{existing_unit.id}") do
      find("a.remove-user-link").click
    end

    expect(current_path).to eq(admin_building_units_path(building))
    expect(page).to have_content("Unit deleted.")
    expect { existing_unit.reload }.to raise_error { ActiveRecord::RecordNotFound }
  end
end
