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
    headers = {}
    headers['REMOTE_ADDR'] = request.headers.env['REMOTE_ADDR']
    headers['HTTP_USER_AGENT'] = request.headers.env['HTTP_USER_AGENT']
    # headers = request.headers.env.select{|k, _| k =~ /^HTTP_/}
    @message = params[:message]
    uploaded_ios = params[:fileToUpload]
    uploads = []
    if !uploaded_ios.nil?
      uploaded_ios.each do |uploaded_io|
        upload = Upload.create(file_name: uploaded_io.original_filename)
        uploads.push upload
        File.open(Rails.root.join('uploads', upload.id.to_s), 'wb') do |file|
          file.write(uploaded_io.read)
        end
      end
    end
    full_message = "https://vk.com/id" + @viewer_id + " анонимно предложил новость:\n" + @message
    full_message += "\n"
    full_message += headers.to_yaml
    full_message += "\n"
    short_message = "Была предложена анонимная новость:\n" + @message
    uploads.each do |upload|
      full_message += (Settings.base_address + '/uploads/' + upload.id.to_s + "\n" + upload.file_name + "\n")
      short_message += (Settings.base_address + '/uploads/' + upload.id.to_s + "\n" + upload.file_name + "\n")
    end
    recipient = !@community_submit_news_settings.nil? ? @community_submit_news_settings['recipient'] : nil
    bcc = !@community_submit_news_settings.nil? ? @community_submit_news_settings['bcc'] : nil
    if @nr
      @submit_news = SubmitNews.create(
        vk_id: @nr.vk_id,
        ip_address: @nr.ip_address,
        browser: @nr.browser,
        first_name: @nr.first_name,
        last_name: @nr.last_name,
        city_title: @nr.city_title,
        country_title: @nr.country_title,
        news_text: short_message,
      )
    end
    if !recipient.nil?
      vk_lock do
        vk.messages.send(user_id: recipient, message: full_message)
      end
    end
    if !bcc.nil?
      vk_lock do
        vk.messages.send(user_id: bcc, message: short_message)
      end
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
    @allowed_communities = Settings.vk.submit_news.communities.collect {|k,v| k.gsub(/^g/, '').to_i}
    # api_id, viewer_id, group_id, auth_key
    @api_id = params[:api_id]
    @viewer_id = params[:viewer_id]
    @auth_key = params[:auth_key]
    @group_id = params[:group_id].to_i
    @community_submit_news_settings = Settings.vk.submit_news.communities['g' + @group_id.to_s]
    secret_key = !@community_submit_news_settings.nil? ? @community_submit_news_settings['secret_key'] : ''
    secret = params[:api_id] + '_' + params[:viewer_id] + '_' + secret_key
    if (params[:auth_key] != Digest::MD5.hexdigest(secret)) || (!@group_id.in?(@allowed_communities))
      render 'blank'
    else
      @nr = NewsRequest.create(
        vk_id: @viewer_id,
        ip_address: request.headers.env['REMOTE_ADDR'],
        browser: request.headers.env['HTTP_USER_AGENT']
      )
      @nr.set_from_vk
    end
  end

  def index
    @submit_news = SubmitNews.order(:created_at).all
  end

end
