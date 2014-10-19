json.array!(@sensors) do |sensor|
  json.extract! sensor, :id, :title, :company, :company_link, :sensor_link, :description
  json.url sensor_url(sensor, format: :json)
end
