require 'spec_helper'

feature "Press" do
  scenario "viewing page" do
    visit press_path
    expect(page).to have_content "Press"
  end

  scenario "viewing article" do
    5.times do |n|
      FactoryBot.create(:article, title: "Fantastic title #{n}", published_date: n.days.ago)
    end

    visit press_path

    title = page.first(".article-title").text
    source = page.first(".source").text
    description = page.first(".description").text

    #TODO: This test passes if you do .last instead of .first
    #but not sure is expected behavior; upgradeing to FactoryBot
    #revealed a test that would always pass, so unclear what
    #desired behavior is
    article = Article.order(published_date: :desc).first

    expect(title).to eq article.title
    expect(source).to include article.company
    expect(source).to include article.published_date.strftime('%Y-%m-%d');
    expect(description).to include article.description
  end
end
