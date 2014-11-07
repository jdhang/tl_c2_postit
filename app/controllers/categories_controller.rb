class CategoriesController < ApplicationController
  before_action :require_user, only: [:new, :create]
  
  def new
    @category = Category.new
  end

  def show
    @category = Category.find_by(slug: params[:id])
    @posts = @category.posts
  end

  def create
    @category = Category.new(category_params)
    
    if @category.save
      flash[:notice] = "The category was created!"
      redirect_to '/posts'
    else
      render :new
    end
  end

  private
    def category_params
      params.require(:category).permit(:name)
      
    end

end