class PostsController < ApplicationController

  before_action :set_post, only: [:show]

  def show

  end

  def comments
    respond_to do |format|
      format.json { render json: PostCommentsDatatable.new(view_context) }
    end
  end

  private

  def set_post
    @post = Post.find params[:id]
  end

end