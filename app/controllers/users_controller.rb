class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Registration was successful!"
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end

  end

  def edit
  end

  def update
    
    if @user.update(user_params)
      flash[:notice] = "Update was successful!"
      redirect_to user_path(@user)
    else
      render :edit
    end

  end

  def posts
    respond_to do |format|
      format.js do
      end
    end
  end

  def comments
    respond_to do |format|
      format.js do
      end
    end

  end


  private
    def user_params
      params.require(:user).permit(:username, :password, :time_zone)
    end

    def set_user
      @user = User.find_by(slug: params[:id])
    end

    def require_same_user
      if current_user != @user
        flash[:error] = "You do not have permission to do that!"
        redirect_to user_path(current_user)
      end
    end

end