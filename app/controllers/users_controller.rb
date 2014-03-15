class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  # before_action :set_user, only: [:show, :new, :update, :destroy]
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(new_user_params)
    if @user.valid?
      @user.save
      redirect_to "/users"
    else
      @user
      render action: 'new'
    end
  end

  def show
    if current_user.id == params[:id]
      @user = User.find(params[:id])
    else
      redirect_to "/users/sign_in"
    end
  end

  private
    def set_user
      
    end

    def new_user_params
      params.require(:user).permit(:first_name, :last_name, :address, :email)
    end

end
