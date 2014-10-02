require 'spec_helper'

describe "articles/show" do
  before(:each) do
    @article = assign(:article, stub_model(Article,
      :title => "Title",
      :company => "Company",
      :company_link => "Company Link",
      :article_link => "Article Link",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Company/)
    rendered.should match(/Company Link/)
    rendered.should match(/Article Link/)
    rendered.should match(/MyText/)
  end
end
