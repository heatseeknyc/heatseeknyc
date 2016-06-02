class WelcomeController < ApplicationController
  require "will_paginate/array"
  BLOG_PAGE_SIZE = 4

  def index
  end

  def judges_welcome
    @judges = User.judges
  end

  def press
    @articles = Article.order(created_at: :desc).to_a
  end

  def thankyou
    render 'thankyou'
  end

  def video
  end

  def blog
    page = params[:page] ? params[:page].to_i : 1
    page_data = blog_posts_data(page)
    total_pages = page_data[:total_pages]
    render 'public/404' if page > total_pages

    @entries = page_data[:posts]
    @entries.define_singleton_method(:total_pages){total_pages}
    @entries.define_singleton_method(:current_page){page}
  end

  private

  def blog_posts_data(page)
    # Cache Tumblr data hourly, on the hour.
    Rails.cache.fetch("blog_page_#{page}_#{Time.now.strftime('%Y%m%d%H')}") do
      Rails.logger.info("\n FETCHING FROM TUMBLR \n")
      client = Tumblr::Client.new(:consumer_key => ENV['TUMBLR_CONSUMER_KEY'],
                                  :consumer_secret => ENV['TUMBLR_CONSUMER_SECRET'],
                                  :oauth_token => ENV['TUMBLR_OAUTH_TOKEN'],
                                  :oauth_token_secret => ENV['TUMBLR_OAUTH_TOKEN_SECRET'])

      result = client.posts(
        'heatseeknyc.tumblr.com',
        :limit => BLOG_PAGE_SIZE,
        :offset => BLOG_PAGE_SIZE * (page - 1)
      )

      {
        :posts => result['posts'].sort{|a, b| b['date'] <=> a['date']},
        :total_pages => result["total_posts"].fdiv(BLOG_PAGE_SIZE).ceil
      }
    end
  end

end
