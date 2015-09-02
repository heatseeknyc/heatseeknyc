require 'spec_helper'

feature "Press" do
  scenario "viewing page" do
    visit press_path
    expect(page).to have_content "Press"
  end

  scenario "viewing article" do
    5.times do
      FactoryGirl.create(:article)
    end

    visit press_path

    title = page.first(".article-title").text
    source = page.first(".source").text
    description = page.first(".description").text

    article = Article.order(published_date: :desc).first

    expect(title).to eq article.title
    expect(source).to include article.company
    expect(source).to include article.published_date.strftime('%Y-%m-%d');
    expect(description).to include article.description
  end
end
