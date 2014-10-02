require 'spec_helper'

describe "articles/edit" do
  before(:each) do
    @article = assign(:article, stub_model(Article,
      :title => "MyString",
      :company => "MyString",
      :company_link => "MyString",
      :article_link => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit article form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", article_path(@article), "post" do
      assert_select "input#article_title[name=?]", "article[title]"
      assert_select "input#article_company[name=?]", "article[company]"
      assert_select "input#article_company_link[name=?]", "article[company_link]"
      assert_select "input#article_article_link[name=?]", "article[article_link]"
      assert_select "textarea#article_description[name=?]", "article[description]"
    end
  end
end
