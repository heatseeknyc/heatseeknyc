require "spec_helper"

feature "Giving Tuesday" do
  def xpath_for_video(src)
    "//video[contains(@src,\"/#{src}\")]"
  end

  def xpath_for_image(src)
    "//img[contains(@src,\"/#{src}\")]"
  end

  scenario "Visiting the Giving Tuesday page" do
    nycharities_url = "https://www.nycharities.org/give/donate.aspx?cc=4081"
    video_embed = "https://www.youtube.com/embed/15hh8EL13FM"

    visit giving_tuesday_path
    expect(page).to have_xpath(xpath_for_image("giving_tuesday_banner.png"))
    expect(page).to have_link("Donate Now", count: 2, href: nycharities_url)
    expect(page).to have_text("Winter is coming")
    expect(page).to have_text("#GivingTuesday")
    expect(page).to have_css("iframe[src=\"#{video_embed}\"]")
  end
end
