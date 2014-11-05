class UsersController < ApplicationController
  before_action :set_user, except: [:new, :create]
  before_action :require_same_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def show
    @user = current_user
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
      redirect_to root_path
    else
      render :edit
    end

  end

  private
    def user_params
      params.require(:user).permit(:username, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def require_same_user
      if current_user != @user
        flash[:error] = "You are not allowed to do that..."
        redirect_to user_path(current_user)
      end
    end

end