class PostsController < ApplicationController
  require "will_paginate/array"
  PAGE_SIZE = 4

  def index
    page = (params[:page] || '1').to_i

    client = Tumblr::Client.new({
      :consumer_key => ENV['TUMBLR_CONSUMER_KEY'],
      :consumer_secret => ENV['TUMBLR_CONSUMER_SECRET'],
      :oauth_token => ENV['TUMBLR_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TUMBLR_OAUTH_TOKEN_SECRET']
    })

    result = client.posts(
      'heatseeknyc.tumblr.com',
      :limit => PAGE_SIZE,
      :offset => PAGE_SIZE * (page - 1)
    )

    total_pages = result["total_posts"].fdiv(PAGE_SIZE).ceil # wtf is this? fdiv?
    render 'public/404' if page > total_pages

    @posts = result['posts'].sort{|a,b| b['date'] <=> a['date']}
    @posts.define_singleton_method(:total_pages){total_pages}
    @posts.define_singleton_method(:current_page){page}
  end
end

