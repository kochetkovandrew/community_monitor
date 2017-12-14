require 'digest'

class SubmitNewsController < ApplicationController

  layout 'blank'
  after_action :allow_iframe
  before_filter :check_auth_key

  def new
    @access_token = params[:access_token]
  end

  private

  def allow_iframe
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://api.vk.com"
  end

  def check_auth_key
    # api_id, viewer_id, group_id, auth_key
    secret = params[:api_id] + '_' + params[:viewer_id] + '_' + Settings.vk.submit_news.secret_key
    if params[:auth_key] != Digest::MD5.hexdigest(secret)
      render 'blank'
    end
  end

end
