require 'spec_helper'

feature "Sensor Codes" do

  scenario "creating a new user account with a sensor code" do
    sensor = create(:sensor, name: 'abcdefghijklmnop', nick_name: '3E4T')

    visit '/users/sign_up'
    fill_in 'First name', with: 'Maximus'
    fill_in 'Last name', with: 'O\'Connor'
    fill_in 'Address', with: '120 New St'
    fill_in 'Zip code', with: '19382'
    fill_in 'Sensor code', with: '3e4t'
    fill_in 'Email', with: 'maximus@gmail.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_on 'Sign up'
    expect(page).to have_text "You have signed up successfully."

    new_user = User.last
    new_user.reload
    expect(new_user.sensors).to include sensor
    visit edit_user_registration_path(new_user)
    expect(page).to have_selector("input[value='3e4t']")
  end

  scenario "editing an old user account to change a sensor code" do
    sensor = create(:sensor, name: 'abcdefghijklmnop', nick_name: '3E4T')
    user = create(:user, password: 'password')
    login_as(user)

    visit edit_user_registration_path(user)
    fill_in 'Sensor code', with: '3e4t'
    fill_in 'Current password', with: 'password'
    click_button 'Update'

    user.reload
    expect(user.sensors).to include sensor
    visit edit_user_registration_path(user)
    expect(page).to have_selector("input[value='3e4t']")
  end

  scenario "typing an invalid sensor returns a validation error" do
    user = create(:user, password: 'password')
    login_as(user)

    visit edit_user_registration_path(user)
    fill_in 'Sensor code', with: '0000'
    fill_in 'Current password', with: 'password'
    click_button 'Update'

    expect(page).to have_text "Sensor codes string has an invalid sensor code"
  end
end
