class CommentsController < ApplicationController
  before_action :set_post, only: [:create]
  before_action :comment_params, only: [:create]
  before_action :authenticate_user!
  
  def new
  end
def create
	@comment = @post.comments.build(comment_params)
	@comment.user = current_user

	if @comment.save
		ActionCable.server.broadcast "comments",
		render(partial:'comments/comment',object: @comment)
		flash[:notice] = 'Comment has been created'
    else
      flash[:alert] = 'Comment has not been created'
    end

end
 private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end


end
