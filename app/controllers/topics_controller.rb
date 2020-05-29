class TopicsController < ApplicationController

  before_action { |f| f.require_permission! 'Communities' }
  before_action :set_user_permissions
  before_action :set_topic, only: [:show, :comments, :vk_view]
  layout 'vk', only: :vk_view

  def vk_view

  end

  def show

  end

  def comments
    respond_to do |format|
      format.json { render json: TopicCommentsDatatable.new(view_context) }
    end
  end

  private

  def set_user_permissions
    @user_permissions = PermissionUser.where(user_id: current_user.id)
    @user_permission_ids = @user_permissions.collect{|user_permission| user_permission.permission_id}
  end

  def set_topic
    @topic = Topic.find params[:id]
    if !(@user_permission_ids.include? @topic.community.permission_id)
      insufficient_permissions
    end
  end


end