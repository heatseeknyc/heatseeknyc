class WelcomeController < ApplicationController

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

end

