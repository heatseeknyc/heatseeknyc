require 'spec_helper'

feature "Tenant Dashboard" do
  scenario "viewing after successful login" do
    user = login_as_tenant
    FactoryGirl.create(:reading, user: user, created_at: DateTime.new(2018, 12, 1))

    visit user_path(user)

    expect(page).to have_content user.name
    expect(page).to have_content user.address
    expect(page).to have_content user.zip_code
    expect(page).to have_content user.current_temp
    expect(page).to have_content user.violation_count

    expect(page).to have_link("PDF 2018 - 2019")
    expect(page).to have_link("CSV", href: csv_download_path(user))

    # Tried testing rendered js chart using the poltergeist driver, but
    # it got painful - spec slowed to 5 secs (from 300ms), and
    # still barfed a javascript error - https://gist.github.com/oliverbarnes/d1ee777f4e55fb5f912f0,
    # thought the feature works when testing manually. Could be a rabbit hole to debug.
    #
    # Thinking it might be worth going with native js unit tests (mocha or jasmine)
    # for the graph instead, though we'd loose full integration testing of the dash.
    # Good enough?
  end
end
