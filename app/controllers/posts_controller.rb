class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:edit, :update, :destroy]

    def index
        @posts = Post.all
    end

    def show 
        @comment = Comment.new
        @post = Post.find(params[:id])
    end

    def new 
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)
        respond_to do |format|
            if @post.save
                format.html {redirect_to posts_path}
                format.turbo_stream
            else
                format.html {render :new}
                format.turbo_stream { render turbo_stream: turbo_stream.replace(@post, partial: 'posts/form', locals: { post: @post }) }
            end
        end
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update
        respond_to do |format|
            if @post.update(post_params)
                format.html {redirect_to posts_path}
                format.turbo_stream
            else
                format.html {render :edit}
                format.turbo_stream { render turbo_stream: turbo_stream.replace(@post, partial: 'posts/form', locals: { post: @post }) }
            end
        end
    end

    def destroy
        @post.destroy
        respond_to do |format|
          format.html { redirect_to posts_path}
          format.turbo_stream { render turbo_stream: turbo_stream.remove(@post) }
        end
      end
    
      private
    
      def set_post
        @post = Post.find(params[:id])
      end
    
      def post_params
        params.require(:post).permit(:title, :content, :image)
      end
end
