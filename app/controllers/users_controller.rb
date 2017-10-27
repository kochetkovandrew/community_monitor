class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def profile
    @user = current_user
  end

  private
  def set_user

  end

end