require "spec_helper"

feature "Signing up for an account" do
  scenario "from the sign up page" do
    user = login_as_tenant(
      password: "password",
      password_confirmation: "password"
    )

    visit edit_user_registration_path
    fill_in "First name", with: "Oscar"
    fill_in "Last name", with: "#{user.last_name} the Third"
    fill_in "Address", with: "123 Sesame St"
    fill_in "Apartment", with: "2H"
    fill_in "Phone number", with: "555-555-5555"
    fill_in "Zip code", with: "99999"
    fill_in "Email", with: "oscar@sesamestreet.com"
    fill_in "Current password", with: "password"
    click_on "Update"

    expect(page).to have_content "You updated your account successfully."
  end
end
