class CommentsController < ApplicationController
  before_action :require_user


  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "The comment was added!"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @post = Post.find_by(slug: params[:post_id])
    @comment = @post.comments.find(params[:id])
    @vote = @comment.votes.create(vote: params[:vote], voteable: @comment, user_id: current_user.id)

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
    def comment_params
      params.require(:comment).permit!
    end
end