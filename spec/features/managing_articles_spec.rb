require 'spec_helper'

feature "Managing articles" do
  let(:article) { FactoryBot.build(:article) }

  scenario "Viewing articles" do
    article1 = FactoryBot.create(:article, published_date: 3.days.ago)
    article2 = FactoryBot.create(:article, published_date: 2.days.ago)
    article3 = FactoryBot.create(:article, published_date: 1.day.ago)

    login_as_team_member
    click_link "Articles"

    expect(page).to have_content "Articles"
    [article1, article2, article3].each do |article|
      expect(page).to have_content article.title
      expect(page).to have_content article.description
    end
  end

  scenario "Creating" do
    login_as_team_member
    click_link "Articles"
    click_link "New Article"

    fill_in "Title", with: article.title
    fill_in "Company", with: article.company
    fill_in "Published date", with: article.published_date
    fill_in "Company link", with: article.company_link
    fill_in "Article link", with: article.article_link
    fill_in "Description", with: article.description
    click_on "Create Article"

    expect(page).to have_content "Article was successfully created."
    expect(page).to have_content "Title: #{article.title}"
    expect(page).to have_content "Company: #{article.company}"
    expect(page).to have_content "Published Date: #{article.published_date}"
    expect(page).to have_content "Company link: #{article.company_link}"
    expect(page).to have_content "Article link: #{article.article_link}"
    expect(page).to have_content "Description: #{article.description}"

  end

  scenario "Updating" do
    article.save
    login_as_team_member

    visit articles_path(article)
    click_on "Edit"
    fill_in "Title", with: "New Title"
    click_on "Update Article"

    expect(current_path).to eq article_path(article)
    expect(page).to have_content "Article was successfully updated."
    expect(page).to have_content "New Title"
  end
end
