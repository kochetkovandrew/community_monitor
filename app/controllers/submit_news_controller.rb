require 'digest'

class SubmitNewsController < ApplicationController

  layout 'blank', only: [:new, :create]
  skip_before_action :verify_authenticity_token, only: [:create]
  after_action :allow_iframe, only: [:new, :create]
  before_action :check_auth_key, only: [:new, :create]
  before_action :authenticate_user!, only: [:index]
  before_action :set_submit_news, only: [:show, :edit, :update]
  before_action only: [:index] do |f|
    f.require_permission! 'DetivichAdmin'
  end

  def index
    @community_key = CommunityKey.where(vk_id: params[:community_vk_id])
    if !@community_key.nil?
      if current_user.admin_of.include? @community_key.vk_id
        @submit_news_all = SubmitNews.order('created_at desc').
          where(community_vk_id: @community_key.vk_id).all
      end
    end
  end

  def show

  end

  def edit

  end

  def new
    @access_token = params[:access_token]
    @community_key = CommunityKey.where(vk_id: @group_id).first
    if @community_key.nil? || @community_key.key.nil?
      render 'access'
    else
      render 'new'
    end
  end

  def create
    @community_key = CommunityKey.where(vk_id: @group_id).first
    if !@community_key.nil?
      # vk = VkontakteApi::Client.new Settings.vk.user_access_token
      vk_group = VkontakteApi::Client.new @community_key.key

      headers = {}
      headers['REMOTE_ADDR'] = request.headers.env['REMOTE_ADDR']
      headers['HTTP_USER_AGENT'] = request.headers.env['HTTP_USER_AGENT']
      @message = params[:message]
      uploaded_ios = params[:fileToUpload]
      uploads = []
      if !uploaded_ios.nil?
        uploaded_ios.each do |uploaded_io|
          upload = Upload.create(file_name: uploaded_io.original_filename)
          uploads.push upload
          suffix = File.extname(upload.file_name)
          File.open(Rails.root.join('uploads', 'file' + upload.id.to_s + suffix), 'wb') do |file|
            file.write(uploaded_io.read)
          end
        end
      end
      if @nr
        @submit_news = SubmitNews.create(
          vk_id: @nr.vk_id,
          ip_address: @nr.ip_address,
          browser: @nr.browser,
          first_name: @nr.first_name,
          last_name: @nr.last_name,
          city_title: @nr.city_title,
          country_title: @nr.country_title,
          news_text: @message,
          community_vk_id: @community_key.vk_id,
        )
      end
      uploads.each do |upload|
        SubmitNewsUpload.create(
          submit_news_id: @submit_news.id,
          upload_id: upload.id,
        )
      end
      short_message = "Была предложена анонимная новость:\n" + @message
      # upload_server = vk_lock { vk_group.docs.get_wall_upload_server(group_id: @community_key.vk_id) }
      # upload_server = vk_lock { vk_group.docs.get_messages_upload_server(type: 'doc', peer_id: -@group_id) }
      # upload_docs = []
      # uploads.each do |upload|
      #   mime_type = MIME::Types.type_for(upload.file_name).first.content_type
      #   suffix = File.extname(upload.file_name)
      #   upload_file = vk_lock { VkontakteApi.upload(url: upload_server[:upload_url], file: [(Rails.root.join('uploads', 'file' + upload.id.to_s + suffix)).to_s, mime_type]) }
      #   upload_doc = vk_lock { vk_group.docs.save(file: upload_file[:file], title: upload.file_name) }
      #   upload_docs.push upload_doc[0]
      # end
      # vk_lock do
      #   vk_group.messages.send(
      #     user_id: -@group_id,
      #     message: short_message,
      #     # attachment: upload_docs.collect{ |upload_doc| 'doc' + upload_doc[:owner_id].to_s + '_' + upload_doc[:id].to_s }.join(',')
      #   )
      # end

      # vk_lock do
      #   vk_group.wall.post(
      #     owner_id: -@group_id,
      #     from_group: 1,
      #     message: @message,
      #     attachments: upload_docs.collect{ |upload_doc| 'doc' + upload_doc[:owner_id].to_s + '_' + upload_doc[:id].to_s }.join(','),
      #     publish_date: (Date.today >> 12).to_time.to_i,
      #     guid: Digest::MD5.hexdigest('News' + @submit_news.id.to_s)
      #   )
      # end
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.json { render json: 'Something went wrong', status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @submit_news.update(submit_news_params)
        format.html { redirect_to @submit_news, notice: 'News was successfully updated.' }
        format.json { render :show, status: :ok, location: @submit_news }
      else
        format.html { render :edit }
        format.json { render json: @submit_news.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def allow_iframe
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://api.vk.com"
    response.headers.delete_if{|key| key.upcase=='X-FRAME-OPTIONS'}
  end

  def check_auth_key
    if !Rails.env.development?
      @allowed_communities = Settings.vk.submit_news.communities.collect {|k,v| k.gsub(/^g/, '').to_i}
      # api_id, viewer_id, group_id, auth_key
      @api_id = params[:api_id]
      @viewer_id = params[:viewer_id]
      @auth_key = params[:auth_key]
      @group_id = params[:group_id].to_i
      # @community = Community.where(vk_id: @group_id).first
      @community_key = CommunityKey.where(vk_id: @group_id).first
      @community_submit_news_settings = Settings.vk.submit_news.communities['g' + @group_id.to_s]
      secret_key = !@community_submit_news_settings.nil? ? @community_submit_news_settings['secret_key'] : ''
      secret = params[:api_id] + '_' + params[:viewer_id] + '_' + secret_key
      if (params[:auth_key] != Digest::MD5.hexdigest(secret)) || (!@group_id.in?(@allowed_communities)) || @community_key.nil?
        render 'blank'
      else
        @nr = NewsRequest.create(
          vk_id: @viewer_id,
          ip_address: request.headers.env['REMOTE_ADDR'],
          browser: request.headers.env['HTTP_USER_AGENT'],
          community_vk_id: @community_key.vk_id,
        )
        @nr.set_from_vk
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_submit_news
    @submit_news = SubmitNews.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def submit_news_params
    params.require(:submit_news).permit([:status, :news_text, :answer])
  end

end
