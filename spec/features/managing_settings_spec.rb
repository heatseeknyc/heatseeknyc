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

    fill_in_new_personal_info(user)

    expect(page).to have_content "You updated your account successfully"
    expect(page).to have_content "Helping New York City keep the heat on."
  end
end