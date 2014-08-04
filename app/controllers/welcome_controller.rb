class WelcomeController < ApplicationController
  require "will_paginate/array"

  def index
    # redirect_to current_user if current_user
    # render "current_user_index" if current_user
  end

  def blog
    client = Tumblr::Client.new({
      :consumer_key => 'CEOhpSLV95qmGJqfiDU2OFVohJctU0h2yN5gku605aeeoXfiMB',
      :consumer_secret => '404m3BAXx4HRv0YuzBtbk2YdgG4rPrhys7SCFkHugOlM9WkYsO',
      :oauth_token => 'Aea7rOSFfEvAfE5MmBiYIHHQl4BkKHzdcyfZrZtgx7p2jWyBoM',
      :oauth_token_secret => 'mJOy2poC33vsLRfRtpWryqeyYUAK9S2fVA23fsIVkjGbqpGnJe'
    })
    result = client.posts('heatseeknyc.tumblr.com')['posts']
    
    @entries = WillPaginate::Collection.create(1, 4, result.count) do |pager|
      pager.replace(result)
    end

    @entries.paginate(:page => params[:page], :per_page => 4)
  end
end
