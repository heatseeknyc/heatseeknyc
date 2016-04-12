require "spec_helper"

feature "Managing settings" do
  let(:user) { login_as_tenant }

  before do
    user
    click_link "My Settings"
  end

  scenario "Viewing settings" do
    expect(page).to have_content "First name"
    expect(page).to have_selector("input[value='#{user.first_name}']")

    expect(page).to have_content "Last name"
    expect(page).to have_selector("input[value='#{user.last_name}']")

    expect(page).to have_content "Address"
    expect(page).to have_selector("input[value='#{user.address}']")

    expect(page).to have_content "Zip code"
    expect(page).to have_selector("input[value='#{user.zip_code}']")

    expect(page).to have_content "Email"
    expect(page).to have_selector("input[value='#{user.email}']")
  end

  scenario "Updating" do
    within("form[name='edit-user']") do
      fill_in "First name", with: "Howling"
      fill_in "Last name", with: "Wolf"
      fill_in "Address", with: "Chicago"
      fill_in "Zip code", with: "11111"
      fill_in "Email", with: "wolfster@email.com"
    end

    fill_in "Current password", with: user.password
    click_button "Update"

    expect(user.reload.first_name).to eq "Howling"
    expect(current_path).to eq(root_path)
    expect(page).to have_content "You updated your account successfully"
    expect(page).to have_content "Helping New York City keep the heat on."
  end

  scenario "Updating without entering current password" do
    click_button "Update"
    expect(user.reload.first_name).to_not eq "Howling"
    expect(page).to have_content "Current password can't be blank"
  end

  scenario "Cancel account" do
    expect { click_button "Cancel my account" }.to change { User.count }.by(-1)
    expect(current_path).to eq(root_path)
    expect(page).to have_content "Your account was successfully cancelled."
  end
end
