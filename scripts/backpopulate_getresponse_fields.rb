# run on heroku with:
# cat scripts/backpopulate_getresponse_fields.rb | heroku run console -a heatseek-prod  --no-tty


auth_token = "api-key #{ENV['GET_RESPONSE_API_KEY']}"
response = HTTParty.get(
  "https://api.getresponse.com/v3/contacts",
  query: {
    perPage: 300,
    query: {
      campaignId: ENV['GET_RESPONSE_LIST_TOKEN']
    }
  },
  headers: {
    "Content-Type": "application/json",
    "X-Auth-Token": auth_token
  }
)

# field_response = HTTParty.get(
#   "https://api.getresponse.com/v3/custom-fields",
#   query: {
#     perPage: 300,
#     # query: {
#     #   campaignId: ENV['GET_RESPONSE_LIST_TOKEN']
#     # }
#   },
#   headers: {
#     "Content-Type": "application/json",
#     "X-Auth-Token": auth_token
#   }
# )
# pp field_response

response.each_with_index do |contact, ix|
  # pp contact

  db_user = User.find_by(email: contact["email"])
  if db_user.blank?
    puts "not found in DB: #{contact["email"]}"
    next 
  end

  puts db_user.first_name
  puts db_user.last_name

  response = HTTParty.post(
    "https://api.getresponse.com/v3/contacts/#{contact["contactId"]}",
    headers: {
      "Content-Type": "application/json",
      "X-Auth-Token": auth_token
    },
    body: {
      email: db_user.email,
      customFieldValues: [
        { customFieldId: "pMnvrJ", value: [db_user.first_name] },
        { customFieldId: "pMKFRN", value: [db_user.last_name] },
      ]
    }.to_json
  )
  puts "#{ix}, #{contact["email"]}, success? #{response.success?}"
  # pp response
end