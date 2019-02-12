class CommunityKeysController < ApplicationController

  before_action :check_auth_key
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    if @authorized
      community_key = CommunityKey.where(vk_id: @group_id).first
      if !community_key
        community_key = CommunityKey.create(
          vk_id: @group_id,
          key: params[:community_key]
        )
      end
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.json { render json: 'Something went wrong', status: :unprocessable_entity }
      end
    end
  end

  private

  def check_auth_key
    # api_id, viewer_id, group_id, auth_key
    @api_id = params[:api_id]
    @viewer_id = params[:viewer_id]
    @auth_key = params[:auth_key]
    @group_id = params[:group_id].to_i
    secret_key = Settings.vk.submit_news.app_secret
    secret = params[:api_id] + '_' + params[:viewer_id] + '_' + secret_key
    if (params[:auth_key] != Digest::MD5.hexdigest(secret))
      @authorized = false
    else
      @authorized = true
    end
  end

end