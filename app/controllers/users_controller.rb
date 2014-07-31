class UsersController < ApplicationController
  include UserControllerHelper
  before_action :authenticate_user!, except: [:demo]

  def edit
    @user = User.find(params[:id])
    render "demo_edit" if current_user.is_demo_user?
  end

  def update
    @user = User.find(params[:id])
    @user.update_without_password(user_params)
    @collaboration = current_user.collaborations.where(collaborator_id: @user.id).first
    redirect_to "/users/#{current_user.id}/collaborations/#{@collaboration.id}"
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
    binding.pry
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

  def live_update
    user = User.find_by(first_name: "Live Update")
    user.readings.first.destroy if user.readings.count > 50
    user.readings.delete_all if user.readings.count > 60

    respond_to do |f|
      f.html
      f.js
    end
  end

  def demo
    demo = User.find_by(email: 'demo-lawyer@heatseeknyc.com')
    sign_in(demo)
    redirect_to user_path(demo)
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :address, :email, :zip_code, :permissions, :twine_name)
    end
end
