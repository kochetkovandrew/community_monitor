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
    uploaded_ios.each do |uploaded_io|
      upload = Upload.create(file_name: uploaded_io.original_filename)
      uploads.push upload
      File.open(Rails.root.join('uploads', upload.id.to_s), 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end
    full_message = "https://vk.com/id" + @viewer_id + " анонимно предложил новость:\n" + @message
    full_message += "\n"
    full_message += headers.to_yaml
    full_message += "\n"
    uploads.each do |upload|
      full_message += ('http://euve258423.serverprofi24.de/uploads/' + upload.id.to_s + "\n" + upload.file_name + "\n")
    end

    recipient = 305013709
    if @group_id == 133980650
      recipient = 4048980
    end
    vk_lock do
      vk.messages.send(user_id: recipient, message: full_message)
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
    @group_id = params[:group_id].to_i
    secret = params[:api_id] + '_' + params[:viewer_id] + '_' + Settings.vk.submit_news.secret_key
    if (params[:auth_key] != Digest::MD5.hexdigest(secret)) || ((@group_id != 133980650) && (@group_id != 69659144) && (@group_id != 125285515))
      render 'blank'
    end
  end

end
