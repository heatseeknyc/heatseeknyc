class WelcomeController < ApplicationController

  def index
    # redirect_to current_user if current_user
    # render "current_user_index" if current_user
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

end

