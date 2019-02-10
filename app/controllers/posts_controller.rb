class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Communities' }
  before_action :set_user_permissions
  before_action :set_post, only: [:show, :vk_view, :comments]
  layout 'vk', only: :vk_view

  def vk_view
    actor_vk_ids ||= [ @post.raw['from_id'] ]
    @post.post_comments.each do |comment|
      actor_vk_ids.push comment.user_vk_id
      actor_vk_ids.push comment.raw['reply_to_user']
    end

    actor_vk_ids.compact!
    #members
    member_vk_ids = actor_vk_ids.select{|id| id>0}
    members = Member.
      where(vk_id: member_vk_ids).
      where('updated_at > ?', (Time.current - 2.days)).
      where("raw ? 'first_name_dat'").all
    existing_member_vk_ids = members.collect{|member| member.vk_id}
    not_known = member_vk_ids - existing_member_vk_ids
    new_members = []
    if !not_known.empty?
      new_members = Member::get_from_vk(not_known, {update_existing: true})
    end

    #communities
    community_vk_ids = actor_vk_ids.select{|id| id<0}.collect{|id| -id}
    communities = Community.
      where(vk_id: member_vk_ids).
      where('updated_at > ?', (Time.current - 2.days)).all
    existing_community_vk_ids = communities.collect{|community| community.vk_id}
    not_known = community_vk_ids - existing_community_vk_ids
    new_communities = []
    if !not_known.empty?
      new_communities = Community::get_from_vk(not_known, {update_existing: true})
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
      @members_map[member.vk_id] = {full_name: full_name, avatar: avatar, sex: member.sex, first_name_dat: member.raw['first_name_dat']}
    end
    (communities + new_communities).each do |community|
      avatar = 'https://vk.com/images/camera_50.png'
      full_name = 'Неизвестно'
      begin
        full_name = community.raw['name']
        avatar = community.raw['photo_50']
      rescue
      end
      @members_map[-community.vk_id] = {full_name: full_name, avatar: avatar, sex: 2, first_name_dat: 'Сообществу'}
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

  def set_user_permissions
    @user_permissions = PermissionUser.where(user_id: current_user.id)
    @user_permission_ids = @user_permissions.collect{|user_permission| user_permission.permission_id}
  end

  def set_post
    @post = Post.find params[:id]
    if !(@user_permission_ids.include? @post.community.permission_id)
      insufficient_permissions
    end
  end

end