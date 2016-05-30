require "spec_helper"

feature "Managing buildings" do
  let(:building) { create(:building) }

  before { login_as_admin }

  scenario "Viewing" do
  end

  scenario "Creating" do
    visit "/admin/buildings/new"
    fill_in "Property name", with: "New apartment"
    fill_in "Street address", with: "123 New St"
    fill_in "Zip code", with: "99999-1234"
    fill_in "Bin", with: "123456789"
    fill_in "Bbl", with: "123-4-5678"

    click_button "CREATE"

    new_building = Building.last
    expect(new_building.property_name).to eq("New apartment")
    expect(new_building.street_address).to eq("123 New St")
    expect(current_path).to eq(admin_buildings_path)
    expect(page).to have_content("Successfully created.")
  end

  scenario "Updating" do
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
end
