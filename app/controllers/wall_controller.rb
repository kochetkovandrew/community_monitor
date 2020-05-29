class WallController < ApplicationController

  before_action :authenticate_user!
  before_action :set_community, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.json { render json: WallDatatable.new(view_context, @community) }
    end
  end

  private

  def set_community
    @community = Community.find_by_screen_name Rails.application.credentials.vk[:public_community]
  end

end