class PostsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_post, only:[:show, :edit, :update, :destroy]
	def index
		@post = Post.all
	end

	def new
		@post = current_user.posts.build
	end

	def show
		@comment = @post.comments.build
		@comments = @post.comments.includes(:user)
	end

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			redirect_to post_path(@post), notice: "Success"
		else
			flash.now[:warning] = 'The post has been created!'
			render 'new'
		end
	end

	def edit 
	    unless @post.user == current_user
			flash[:alert] = "This is not your post!"
			redirect_to root_path
		end
	end

	def update
		unless @post.user == current_user
			flash[:danger] = "This is not your post!"
			redirect_to root_path
		else
			if @post.update(post_params)
				redirect_to post_path(@post), notice: "The post has been updated!"
			else
				flash.now[:alert] = "Post has not been updated!"
				render 'edit'
			end
		end	
	end

	def destroy
    unless @post.user == current_user
      redirect_to root_path, alert: "This is not your post!"
    else
       if @article.destroy
        redirect_to root_path, notice: "Article has been deleted"
       end
    end
  end



	private
	def post_params
		params.require(:post).permit(:title, :text)
	end

	def set_post
    @post = Post.find(params[:id])
    end
end
