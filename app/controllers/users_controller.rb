class UsersController < ApplicationController
  before_action :authenticate_user!, except: :welcome

  def welcome
    if current_user
      redirect_to "/users/#{current_user.id}"
    else
      redirect_to "/users/sign_in"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_without_password(user_params)
    redirect_to "/users/#{current_user.id}/collaborations/#{@user.id}"
  end

  def index
    if current_user.permissions <= 50
      @users = User.all
    else
      redirect_to current_user
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      redirect_to "/users"
    else
      @user
      render action: 'new'
    end
  end

  def show
    render "permissions_show" if current_user.permissions <= 50
  end

  def download_pdf
    writer = PDFWriter.new_from_user_id(params[:id])

    file = writer.generate_pdf
    filename = writer.filename
    type = writer.content_type

    send_data(file, filename: filename, type: type)
  end

  def search
    @query = params[:q]
    @results = User.search(@query).reject {|r| r == current_user}
    respond_to do |f|
      f.html do
        if @results.empty?
          flash[:error] = "Unable to find user #{@query}."
          redirect_to current_user
        end
      end
      f.js
    end
  end

  private
    def set_user
      
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :address, :email, :zip_code, :permissions)
    end
end
