class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_admin, only: [:edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def index
    @posts = Post.all
    @categories = Category.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      flash[:notice] = "The post was created!"
      redirect_to posts_path
    else
      render :new
    end   
  end
  
  def edit
  end

  def update

    if @post.update(post_params)
      flash[:notice] = "The post was updated!"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = @post.votes.create(vote: params[:vote], voteable: @post, user_id: current_user.id)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You have already voted on this post."
        end
        redirect_to :back
      end
      format.js do
      end
    end

  end

  private
    def post_params
      params.require(:post).permit(:title, :url, :description, category_ids: [])
    end

    def set_post
      @post = Post.find_by(slug: params[:id])
    end

    def require_same_user
      access_denied unless logged_in? and ( current_user == @post.user || current_user.admin? )
    end

end
