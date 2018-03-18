class TopicsController < ApplicationController

  before_action :set_topic, only: [:show]

  def show

  end

  def comments
    respond_to do |format|
      format.json { render json: TopicCommentsDatatable.new(view_context) }
    end
  end

  private

  def set_topic
    @topic = Topic.find params[:id]
  end


end