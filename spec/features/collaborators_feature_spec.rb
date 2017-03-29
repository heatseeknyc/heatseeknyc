require 'spec_helper'

describe "viewing other pages", type: :feature do

  before(:each) do
    @unknown_user = create(:user)
    @user = create(:user, first_name: "Walter")
    login_as(@user, scope: :user)
    @collaborator = create(:user, first_name: "Jesse")
    @user.collaborators << @collaborator
  end

  it "will not show you an unknown user's page" do
    visit "/users/#{@unknown_user.id}"
    expect(page).to have_content @user.first_name
  end

  it "will not show search panel" do
    visit "/users/#{@unknown_user.id}"
    expect(page).to_not have_selector(".search-input-container")
  end

end

describe "viewing advocate page as super user", type: :feature do

  let!(:super_user) { login_as_super_user }

  before(:each) do
    @advocate = create(:user, permissions: User::PERMISSIONS[:advocate])
  end

  it "will show search panel" do
    visit "/users/#{@advocate.id}"
    expect(page).to have_selector(".search-input-container")
  end
end
