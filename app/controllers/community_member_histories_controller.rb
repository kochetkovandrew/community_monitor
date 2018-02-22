class CommunityMemberHistoriesController < ApplicationController

  before_action :set_community_member_history, only: [:show, :diff]

  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Detective' }

  def show

  end

  def diff
    @diff = JSON::parse @community_member_history.diff
    Rails.logger.debug @diff
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_community_member_history
    @community_member_history = CommunityMemberHistory.find(params[:id])

  end

end
