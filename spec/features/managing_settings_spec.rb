require 'spec_helper'

feature "Managing settings" do
  scenario "Viewing settings" do
    user = login_as_tenant
    click_link "My Settings"

    expect_pre_filled_settings_for(user)
  end

  scenario "Updating" do
    user = login_as_tenant
    click_link "My Settings"

    within('form[name="edit-user"]') do
      fill_in "First name", with: "Howling"
      fill_in "Last name", with: "Wolf"
      fill_in "Address", with: "Chicago"
      fill_in "Zip code", with: "11111"
      fill_in "Email", with: "wolfster@email.com"
      fill_in "Password", with: "therealking"
      fill_in "Password confirmation", with: "therealking"
      fill_in "Current password", with: user.password
      click_button "Update"
    end

    expect(page).to have_content "You updated your account successfully"
    expect(page).to have_content "Helping New York City keep the heat on."
  end
end