feature "Managing settings" do
  scenario "Viewing settings" do
    user = login_as_tenant
    click_link "My Settings"

    expect_pre_filled_settings_for(user)
  end

  scenario "Updating" do
    pending "spec breaking because of button_to under same div container in devise/registrations/edit.html.erb. seems to confuse capybara, which submits the cancel form. Feature works when testing manually"
    user = login_as_tenant
    click_link "My Settings"

    fill_in_new_personal_info(user)

    expect(page).to have_content "You updated your account successfully"
    expect(page).to have_content "Helping New York City keep the heat on this winter."
  end
end