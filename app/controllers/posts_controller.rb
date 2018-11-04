class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Detective' }
  before_action :set_post, only: [:show, :vk_view]
  layout 'vk', only: :vk_view

  def vk_view
    @member_vk_ids ||= []
    @post.post_comments.each do |comment|
      @member_vk_ids.push comment.user_vk_id
    end
    members = Member.where(vk_id: @member_vk_ids).all
    member_vk_ids = members.collect{|member| member.vk_id}
    not_known = @member_vk_ids - member_vk_ids
    new_members = []
    if !not_known.empty?
      new_members = Member.get_from_vk(not_known)
    end
    @members_map = {}
    (members + new_members).each do |member|
      avatar = 'https://vk.com/images/camera_50.png'
      full_name = 'Неизвестно'
      begin
        full_name = member.raw['first_name'] + ' ' + member.raw['last_name']
        avatar = member.raw['photo_50']
      rescue
      end
      @members_map[member.vk_id] = {full_name: full_name, avatar: avatar}
    end

  end


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