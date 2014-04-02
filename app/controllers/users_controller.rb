class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :welcome, :sign_in]

  def welcome
    if current_user
      redirect_to "/users/#{current_user.id}"
    else
      redirect_to "/users/sign_in"
    end
  end

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
    @user = User.find(params[:id])
    if current_user.collaborator?(params[:id]) || params[:id].to_i == current_user.id
      render action: 'show'
    else
      redirect_to "users/#{current_user.id}"
    end
  end

  def download_pdf
    writer = PDFWriter.new_from_user_id(params[:id])

    file = writer.generate_pdf
    filename = writer.filename
    type = writer.content_type

    send_data(file, filename: filename, type: type)
  end

  def search
    @results = User.search(params[:q])
  end

  private
    def set_user
      
    end

    def new_user_params
      params.require(:user).permit(:first_name, :last_name, :address, :email)
    end

end
