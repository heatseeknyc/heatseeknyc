require 'spec_helper'

describe "viewing other pages", type: :feature do

  before(:each) do
    @user = create(:user, first_name: "Walter")
    login_as(@user, scope: :user)
    @collaborator = create(:user, first_name: "Jesse")
    @user.collaborators << @collaborator
  end

  it "will not show you an unknown user's page" do
    unknown_user = create(:user)
    visit "/users/#{unknown_user.id}"
    expect(page).to have_content @user.first_name
  end
end

# describe "adding collaborators" do

#   client = create(:user, permissions: 100)
  
#   end
