class WelcomeController < ApplicationController
  require "will_paginate/array"

  def index
    # redirect_to current_user if current_user
    # render "current_user_index" if current_user
  end

  def judges_welcome
    @judges = User.judges
  end

  def press
    @articles = Article.order(created_at: :desc).all
  end

  def blog
    page_size = 4
    page = params[:page] ? params[:page].to_i : 1

    client = Tumblr::Client.new({
      :consumer_key => ENV['TUMBLR_CONSUMER_KEY'],
      :consumer_secret => ENV['TUMBLR_CONSUMER_SECRET'],
      :oauth_token => ENV['TUMBLR_OAUTH_TOKEN'],
      :oauth_token_secret => ENV['TUMBLR_OAUTH_TOKEN_SECRET']
    })

    result = client.posts(
      'heatseeknyc.tumblr.com',
      :limit => page_size,
      :offset => page_size * (page - 1)
    )

    total_pages = result["total_posts"].fdiv(page_size).ceil
    render 'public/404' if page > total_pages

    @entries = result['posts'].sort{|a,b| b['date'] <=> a['date']}
    @entries.define_singleton_method(:total_pages){total_pages}
    @entries.define_singleton_method(:current_page){page}
  end
end

