require "spec_helper"

feature "Signing up for an account" do
  scenario "from the sign up page" do
    visit new_user_registration_path
    fill_in "First name", with: "Oscar"
    fill_in "Last name", with: "Grouch"
    fill_in "Address", with: "123 Sesame St"
    fill_in "Apartment", with: "2H"
    fill_in "Phone number", with: "555-555-5555"
    fill_in "Zip code", with: "99999"
    fill_in "Email", with: "oscar@sesamestreet.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_on "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
  end
end
