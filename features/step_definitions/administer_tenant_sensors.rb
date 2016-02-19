World(FactoryGirl::Syntax::Methods)
include Warden::Test::Helpers

Given(/^I am an admin$/) do
  # log in as an admin
  @admin = create(:admin)
  login_as @admin
  visit '/'

  expect(page).to have_text "My Settings"
  expect(page).to have_text "Sign out"
end

Given(/^I have a tenant$/) do
  # create a new tenant and associate to acccount
  tenant = create(:tenant, {:first_name => "Jesse", :last_name => "Pinkman"})
  @admin.collaborators << tenant

  expect(@admin.collaborators).to include tenant
end

When(/^I go to account settings page for the tenant$/) do
  click_on "My Page"
  click_on "wrench"

  expect(page).to have_text "Edit Jesse Pinkman's Settings"
  expect(page).to have_text "First name"
end

When(/^I change the cell number to a new one$/) do
  page.fill_in "user_sensor_codes_string", :with => "A64B, C79D"
end

When(/^I hit save$/) do
  click_on "SAVE"
  save_and_open_page
end

Then(/^I see a status notification about the change at the top$/) do
  expect(page).to have_text "Successfully updated sensor code string to be A64B, C79D"
end

Then(/^I see that the cell number is updated$/) do
  expect(page).to have_text "A64B, C79D"
end
