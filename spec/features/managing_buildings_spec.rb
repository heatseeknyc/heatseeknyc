require "spec_helper"

feature "Building management is restricted to admin users" do
  scenario "Denies access to a non-admin user" do
    login_as_tenant

    visit "/admin/buildings/new"
    expect(current_path).to eq(root_path)

    building = create(:building)
    visit "/admin/buildings/#{building.id}/edit"
    expect(current_path).to eq(root_path)
  end
end

feature "Building management" do
  let(:building) { create(:building) }

  before { login_as_team_member }

  scenario "Viewing index of all buildings" do
    building
    building_2 = create(:building, street_address: "100 Another Street")

    visit "/"
    click_link "Buildings"

    expect(page).to have_content(building.street_and_zip)
    expect(page).to have_content(building_2.street_and_zip)
  end

  scenario "Viewing all units associated with a building" do
    building
    visit admin_buildings_path(building)
    click_link building.street_and_zip
    expect(current_path).to eq(admin_building_units_path(building))
  end

  scenario "Creating a new building" do
    visit "/"
    click_link "Buildings"
    click_link "Create Building"

    fill_in "Property name", with: "New apartment"
    fill_in "Street address", with: "123 New St"
    fill_in "Zip code", with: "99999-1234"
    fill_in "Bin", with: "123456789"
    fill_in "Bbl", with: "123-4-5678"

    click_button "CREATE"

    new_building = Building.last
    expect(new_building.property_name).to eq("New apartment")
    expect(new_building.street_address).to eq("123 new st")
    expect(current_path).to eq(admin_buildings_path)
    expect(page).to have_content("Successfully created.")
  end

  scenario "Creating a building displays validation errors" do
    visit "/admin/buildings/new"
    click_button "CREATE"

    expect(page).to have_content("Save failed due to errors.")
    expect(page).to have_content("can't be blank")
    expect(page).to have_content("can't be blank and should be 12345 or 12345-1234")
  end

  scenario "Updating an existing building" do
    visit "/admin/buildings/#{building.id}/edit"
    fill_in "Property name", with: "Cold apartment"
    fill_in "Description", with: "This place is cold"
    fill_in "Street address", with: "900 Some Street"
    fill_in "Zip code", with: "99999-1234"
    fill_in "Bin", with: "123456789"
    fill_in "Bbl", with: "123-4-5678"

    click_button "UPDATE"

    expect(building.reload.property_name).to eq("Cold apartment")
    expect(current_path).to eq(edit_admin_building_path(building))
    expect(page).to have_content("Successfully updated.")
  end

  scenario "Updating a building displays validation errors" do
    visit "/admin/buildings/#{building.id}/edit"
    fill_in "Street address", with: ""

    click_button "UPDATE"
    expect(page).to have_content("Save failed due to errors.")
    expect(page).to have_content("can't be blank")
    expect(building.reload.street_address).to_not be_blank
  end

  scenario "Deleting a building" do
    building
    visit admin_buildings_path

    within(:css, "li#building-#{building.id}") do
      find("a.remove-user-link").click
    end

    expect(current_path).to eq(admin_buildings_path)
    expect(page).to have_content("Building deleted.")
    expect { building.reload }.to raise_error { ActiveRecord::RecordNotFound }
  end
end
