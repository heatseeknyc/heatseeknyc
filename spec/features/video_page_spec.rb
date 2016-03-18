require "spec_helper"

feature "Viewing Heat Seek video" do
  scenario "from the home page" do
    visit "/"
    click_on "Video"
    video_selector = 'iframe[src="https://player.vimeo.com/video/108858343"]'
    expect(page).to have_css(video_selector)
  end
end
