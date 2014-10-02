require 'spec_helper'

describe "articles/index" do
  before(:each) do
    assign(:articles, [
      stub_model(Article,
        :title => "Title",
        :company => "Company",
        :company_link => "Company Link",
        :article_link => "Article Link",
        :description => "MyText"
      ),
      stub_model(Article,
        :title => "Title",
        :company => "Company",
        :company_link => "Company Link",
        :article_link => "Article Link",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of articles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Company".to_s, :count => 2
    assert_select "tr>td", :text => "Company Link".to_s, :count => 2
    assert_select "tr>td", :text => "Article Link".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
