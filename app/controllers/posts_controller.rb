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
		@comments = @post.comments
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

	private
	def post_params
		params.require(:post).permit(:title, :text)
	end

	def set_post
    @post = Post.find(params[:id])
    end
end
