class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post
    load_and_authorize_resource
  
    def create
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user
  
      respond_to do |format|
        if @comment.save
          format.html { redirect_to post_path(@post)}
          format.turbo_stream { render turbo_stream: turbo_stream.append(@comment) }
        else
          format.html { redirect_to post_path(@post)}
          format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: 'comments/form', locals: { comment: @comment }) }
        end
      end
    end
  
    def edit
      @comment = @post.comments.find(params[:id])
    end
  
    def update
      @comment = @post.comments.find(params[:id])
  
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to post_path(@post)}
          format.turbo_stream { render turbo_stream: turbo_stream.update(@comment) }
        else
          format.html { render :edit }
          format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: 'comments/form', locals: { comment: @comment }) }
        end
      end
    end
  
    def destroy
      @comment = @post.comments.find(params[:id])
      @comment.destroy
  
      respond_to do |format|
        format.html { redirect_to post_path(@post)}
        format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
      end
    end
  
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
  
    def comment_params
      params.require(:comment).permit(:content)
    end
  end
  