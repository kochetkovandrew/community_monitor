class CommunitiesController < ApplicationController

  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Communities' }
  before_action :set_user_permissions
  before_action :set_community, only: [:show, :edit, :update, :destroy, :wall, :topics]
  before_action only: [:new, :edit, :create, :update, :destroy] do |f|
    f.require_permission! 'Detective'
  end

  # after_action :verify_authorized

  # GET /communities
  # GET /communities.json
  def index
    history_ids = CommunityMemberHistory.select('community_id, max(id) as max_id').group('community_id').collect{|cmh| cmh.max_id}
    @histories_hash = Hash[*(CommunityMemberHistory.where(id: history_ids).all.collect{|cmh| [cmh.community_id, cmh]}.flatten)]
    @communities = Community.where(permission_id: @user_permission_ids)
  end

  # GET /communities/1
  # GET /communities/1.json
  def show
  end

  def wall
    respond_to do |format|
      format.html
      format.json { render json: CommunityWallDatatable.new(view_context) }
    end
  end

  def topics
    respond_to do |format|
      format.html
      format.json { render json: CommunityTopicsDatatable.new(view_context) }
    end
  end

  # GET /communities/new
  def new
    @community = Community.new
  end

  # GET /communities/1/edit
  def edit
  end

  # POST /communities
  # POST /communities.json
  def create
    @community = Community.new(community_params)
    community_hash = @community.get_from_vk
    existing = Community.includes([:community_histories]).find_by_vk_id(community_hash[:id])
    if !existing.nil?
      @community = existing
      @community.update_history(community_hash)
    else
      @community.set_from_vk(community_hash)
    end
    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: 'Community was successfully added.' }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1
  # PATCH/PUT /communities/1.json
  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to @community, notice: 'Community was successfully updated.' }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render :edit }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communities/1
  # DELETE /communities/1.json
  def destroy
    # @community.destroy
    respond_to do |format|
      format.html { redirect_to communities_url, notice: 'Community was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_community
      @community = Community.find(params[:id])
      if !(@user_permission_ids.include? @community.permission_id)
        insufficient_permissions
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_params
      params.require(:community).permit([:screen_name, :monitor_members])
    end

    def set_user_permissions
      @user_permissions = PermissionUser.where(user_id: current_user.id)
      @user_permission_ids = @user_permissions.collect{|user_permission| user_permission.permission_id}
    end
end
