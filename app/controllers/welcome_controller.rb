class WelcomeController < ApplicationController
  require "will_paginate/array"

  def index
    # redirect_to current_user if current_user
    # render "current_user_index" if current_user
  end

  def blog
    client = Tumblr::Client.new({
      :consumer_key => ENV['TUMBLR_CONSUMER_KEY'],
      :consumer_secret => ENV['TUMBLR_CONSUMER_SECRET'],
      :oauth_token => ENV['TUMBLR_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TUMBLR_OAUTH_TOKEN_SECRET']
    })
    
    result = client.posts('heatseeknyc.tumblr.com')['posts']
    result.sort!{|a,b| b['date'] <=> a['date']}
    @entries = result
    # @entries = WillPaginate::Collection.create(1, 4, result.count) do |pager|
    #   pager.replace(result)
    # end

    # @entries.paginate(:page => params[:page], :per_page => 4)
  end
end
