require 'spec_helper'

feature "Visiting the blog" do
  scenario "from the dashboard" do
    pending("needs tumblr api keys")
    
    user = login_as_tenant

    VCR.use_cassette('blog') do
      click_link "blog"
    end

    expect(page).to have_content "HEAT SEEK BLOG"
    expect(page).to have_content "Tweets"
  end
end
