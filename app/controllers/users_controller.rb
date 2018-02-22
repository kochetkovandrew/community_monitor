class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :assign_permission, :revoke_permission]
  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Admin' }

  def index
    @users = User.all
  end

  def profile
    @user = current_user
  end

  def show
    @permissions = Permission.all
  end

  def assign_permission
    PermissionUser.create(
      user_id: @user.id,
      permission_id: params[:permission_id]
    )
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def revoke_permission
    PermissionUser.where(user_id: @user.id).where(permission_id: params[:permission_id]).first.delete
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = User.where(id: params[:id]).includes([:permission_users => :permission]).first
  end

end