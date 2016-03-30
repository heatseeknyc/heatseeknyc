require "spec_helper"

feature "Changing my password" do
  let!(:user) { login_as_tenant }
  let(:new_password) { "new_password" }

  before do
    click_link "Change My Password"
  end

  scenario "Updating password successfully" do
    fill_in "Current password", with: user.password
    fill_in "Password", with: new_password
    fill_in "Password confirmation", with: new_password
    click_button "Update"

    expect(current_path).to eq(root_path)
    expect(page).to have_content "Password changed."
  end

  scenario "Updating without entering current password" do
    fill_in "Password", with: new_password
    fill_in "Password confirmation", with: new_password
    click_button "Update"

    expect(current_path).to eq(update_password_users_path)
    expect(page).to have_content "Current password can't be blank"
  end

  scenario "Updating password with invalid password" do
    fill_in "Current password", with: user.password
    fill_in "Password", with: "short"
    fill_in "Password confirmation", with: "short"
    click_button "Update"
    
    expect(current_path).to eq(update_password_users_path)
    expect(page).to have_content "Password is too short (minimum is 8 characters)"
  end
end
