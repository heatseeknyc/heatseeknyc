json.array!(@articles) do |article|
  json.extract! article, :id, :title, :company, :company_link, :article_link, :description
  json.url article_url(article, format: :json)
end
