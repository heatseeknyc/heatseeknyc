require 'spec_helper'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

describe "viewing advocate page as super user", type: :feature do

  let!(:super_user) { login_as_super_user }

  before(:each) do
    @advocate = create(:user, :advocate)
    @user1 = create(:user)
  end

  it "will show search results" do
    visit user_path(@advocate)
    find(:css, ".search-icon").click
    expect(page).to have_selector("#search-results .sidebar-li", count: 1)
  end

  it "will not show tenants who are already collaborators" do
    create(:collaboration, user: @advocate, collaborator: @user1)
    visit user_path(@advocate)
    find(:css, ".search-icon").click
    expect(page).not_to have_selector("#search-results .sidebar-li")
  end
end
