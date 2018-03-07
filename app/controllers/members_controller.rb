class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Detective' }

  def index
    # @members = Member.all
    @member = Member.new
    respond_to do |format|
      format.html
      format.json { render json: MembersDatatable.new(view_context) }
    end
  end

  def new
    @member = Member.new
  end

  def edit
  end

  def create
    @member = Member.new(member_params)
    member_hash = @member.get_from_vk
    existing = Member.includes([:member_histories]).find_by_vk_id(member_hash[:id])
    if !existing.nil?
      @member = existing
      @member.update_history(member_hash)
      @member.is_friend = false
    else
      @member.set_from_vk(member_hash)
      if @member.screen_name.nil?
        @member.screen_name = 'id' + @member.vk_id.to_s
      end
    end
    respond_to do |format|
      if @member.save
        @member.set_friends_followers_from_vk
        format.html { redirect_to members_url, notice: 'Person was successfully added.' }
        format.json { render :show, status: :created, location: members_url }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show
    @member = Member.find(params[:id])
    res = @member.friends_in_communities
    @friend_hash = res[:friends]
    @friends_in_communities = res[:friends_in_communities]
    @member_of = res[:member_of]
  end

  def friends
    @member = Member.find(params[:id])
    @friends = Member.where(vk_id: @member.raw_friends).all
      #.select([:first_name, :last_name, :domain, :city_title, :country_title, :last_seen_at]).all
    @followers = Member.where(vk_id: @member.raw_followers).all
    # @followers = @member.get_followers
  end

  def check
    if params[:member][:screen_name].match(/^\d+$/)
      @member = Member.where(vk_id: params[:member][:screen_name]).first
    else
      @member = Member.where(screen_name: params[:member][:screen_name]).first
    end
    if @member
      respond_to do |format|
        format.html { redirect_to @member }
      end
    else
      @member = Member.new(member_params)
      @member.set_from_vk
      res = @member.friends_in_communities
      p res
      @friend_hash = res[:friends]
      @friends_in_communities = res[:friends_in_communities]
      @member_of = res[:member_of]
    end
  end

  def comments
    @member = Member.find(params[:id])
  end

  def likes
    @member = Member.find(params[:id])
    @post_likes = Post.where("likes::jsonb @> '?'::jsonb", @member.vk_id).select([:id, :vk_id, :community_id]).includes([:community]).order(:created_at)
    @post_comment_likes = PostComment.where("likes::jsonb @> '?'::jsonb", @member.vk_id).select([:id, :vk_id, :post_id]).includes([:post => [:community]]).order(:created_at)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:screen_name, :status)
  end


end