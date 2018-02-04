class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Admin' }

  def index
    @members = Member.all
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
    @member.set_from_vk
    if @member.screen_name.nil?
      @member.screen_name = 'id' + @member.vk_id.to_s
    end
    respond_to do |format|
      if @member.save
        format.html { redirect_to members_url, notice: 'Person was successfully added.' }
        format.json { render :show, status: :created, location: members_url }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    p @member
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
    @friend_hash = res[:friend_hash]
    @friends_in_communities = res[:friends_in_communities]
    @member_of = res[:member_of]
  end

  def friends
    @member = Member.find(params[:id])
    @friends = JSON::parse(@member.raw_friends)
    @followers = @member.get_followers
  end

  def check
    @member = Member.new(member_params)
    @member.set_from_vk
    res = @member.friends_in_communities
    @friend_hash = res[:friend_hash]
    @friends_in_communities = res[:friends_in_communities]
  end

  def comments
    @member = Member.find(params[:id])
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