require "spec_helper"

feature "Viewing Heat Seek video" do
  # All static content has been moved outside the app.
  # Once the transition is complete, delete this spec file.
  xscenario "from the home page" do
    visit "/"
    click_on "Video"
    video_selector = 'iframe[src="https://player.vimeo.com/video/108858343"]'
    expect(page).to have_css(video_selector)
  end
end
