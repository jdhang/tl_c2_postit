class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_categories

  helper_method :current_user, :logged_in?, :post_user?

  def current_user

    @current_user ||= User.find(session[:user_id]) if session[:user_id]

  end

  def logged_in?
    !!current_user
  end

  def post_user?

    params[:post_id].nil? ? id = params[:id] : id = params[:post_id]

    current_user == Post.find_by(slug: id).user ? true : false
  end

  def require_user
    if !logged_in?
      flash[:error] = "You must be logged in to do that!"
      redirect_to root_path
    end
  end

  def set_categories
    @categories = Category.all
  end

end
