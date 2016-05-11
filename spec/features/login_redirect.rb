require "spec_helper"

feature "Sign In Redirect" do
  scenario "Redirect to login when not signed in" do
    visit root_path
    expect(page).to have_text("Sign in")
  end

  scenario "Redirect to user page when signed in" do
    user = create(:user)
    login_as user
    visit root_path
    expect(page).to have_text(user.name)
  end
end
