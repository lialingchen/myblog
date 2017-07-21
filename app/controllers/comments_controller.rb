class CommentsController < ApplicationController
  before_action :set_post, only: [:create, :destroy, :new]
  before_action :comment_params, only: [:create]
  before_action :authenticate_user!
  
  def new
  end
  def create
	@comment = @post.comments.build(comment_params)
	@comment.user = current_user
	respond_to do |format|
		if @comment.save
			format.html { redirect_to @comment, notice: 'Post was successfully created.' }
			format.js
			# ActionCable.server.broadcast "comments",
			# render(partial:'comments/comment',object: @comment)
			# flash[:notice] = 'Comment has been created'
			# format.json{ render :show, status: :created, location: @comment}
	    else
	    	format.html{render :new}
	      flash[:alert] = 'Comment has not been created'
	    end
	end
  end

  def destroy
  	@comment = @post.comments.find(params[:id])
  	@comment.destroy
  	redirect_to post_path(@post)
  end

	private
    def set_post
	    @post = Post.find(params[:post_id])
	end

	def comment_params
	    params.require(:comment).permit(:id,:body)
    end
end
