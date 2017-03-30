require 'spec_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

describe "viewing advocate page as super user", type: :feature do

  let!(:super_user) { login_as_super_user }

  before(:each) do
    @advocate = create(:user, permissions: User::PERMISSIONS[:advocate])
    create(:user, first_name: "User1")
    create(:user, first_name: "User2")
    create(:user, first_name: "User3")
    create(:user, first_name: "User4")
  end

  it "will show search results" do
    visit "/users/#{@advocate.id}"
    find(:css, ".search-icon").click
    expect(page).to have_selector("#search-results .sidebar-li", count: 4)
  end
end
