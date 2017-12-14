require 'digest'

class SubmitNewsController < ApplicationController

  layout 'blank'
  skip_before_action :verify_authenticity_token, only: [:create]
  after_action :allow_iframe
  before_filter :check_auth_key

  def new
    @access_token = params[:access_token]
  end

  def create
    vk = VkontakteApi::Client.new Settings.vk.user_access_token
    @message = params[:message]
    full_message = "https://vk.com/id" + @viewer_id + " предложил новость:\n" + @message
    vk_lock do
      vk.messages.send(user_id: 4048980, message: full_message)
    end
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def allow_iframe
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://api.vk.com"
  end

  def check_auth_key
    # api_id, viewer_id, group_id, auth_key
    @api_id = params[:api_id]
    @viewer_id = params[:viewer_id]
    @auth_key = params[:auth_key]
    secret = params[:api_id] + '_' + params[:viewer_id] + '_' + Settings.vk.submit_news.secret_key
    if params[:auth_key] != Digest::MD5.hexdigest(secret)
      render 'blank'
    end
  end

end
