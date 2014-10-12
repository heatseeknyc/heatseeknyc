require 'spec_helper'

describe Article do
  it "returns false" do
    article = create :article
    expect(article.published_date).to be_a Date
  end
end
