class CopyMessagesController < ApplicationController
  include CopyMessagesHelper

  before_action :set_copy_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Detective' }
  before_action only: :index do |f|
    @dialog = CopyDialog.find(params[:copy_dialog_id])
    f.require_permission!(@dialog.permission.name)
  end

  # GET /copy_messages
  # GET /copy_messages.json
  def index
    # @dialog = CopyDialog.find(params[:copy_dialog_id])
    @copy_dialog_id = params[:copy_dialog_id]
    # @copy_messages = CopyMessage.where(copy_dialog_id: @dialog.id)
    respond_to do |format|
      format.html
      format.json { render json: CopyMessagesDatatable.new(view_context) }
    end
  end

  # GET /copy_messages/1
  # GET /copy_messages/1.json
  def show
  end

  # GET /copy_messages/new
  def new
    @copy_message = CopyMessage.new
  end

  # GET /copy_messages/1/edit
  def edit
  end

  # POST /copy_messages
  # POST /copy_messages.json
  def create
    @copy_message = CopyMessage.new(copy_message_params)

    respond_to do |format|
      if @copy_message.save
        format.html { redirect_to @copy_message, notice: 'Copy message was successfully created.' }
        format.json { render :show, status: :created, location: @copy_message }
      else
        format.html { render :new }
        format.json { render json: @copy_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /copy_messages/1
  # PATCH/PUT /copy_messages/1.json
  def update
    respond_to do |format|
      if @copy_message.update(copy_message_params)
        format.html { redirect_to @copy_message, notice: 'Copy message was successfully updated.' }
        format.json { render :show, status: :ok, location: @copy_message }
      else
        format.html { render :edit }
        format.json { render json: @copy_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /copy_messages/1
  # DELETE /copy_messages/1.json
  def destroy
    @copy_message.destroy
    respond_to do |format|
      format.html { redirect_to copy_messages_url, notice: 'Copy message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def archive
    community = Community.find_by_screen_name(Rails.application.credentials.vk[:archive_community])
    vk = VkontakteApi::Client.new (community.access_token || Rails.application.credentials.vk[:user_access_token])
    topic = Topic.find params[:topic_id]
    copy_messages = CopyMessage.where(id: params[:ids]).all
    text = ''
    attachments = []
    copy_messages.each do |copy_message|
      cite = text_cite(copy_message.raw)
      text += cite[:text]
      attachments += cite[:attachments]
      text += "\n\n" if copy_message != copy_messages.last
    end
    photos = attachments.select {|attachment| attachment.kind == 'photo'}
    docs = attachments.select {|attachment| attachment.kind == 'doc'}
    upload_media = []
    if photos.count > 0
      upload_server = vk_lock { vk.photos.get_wall_upload_server(group_id: community.vk_id) }
      photos.each do |photo|
        upload_file = vk_lock { VkontakteApi.upload(url: upload_server[:upload_url], photo: [(Rails.root.join('attachments', photo.local_filename).to_s), 'image/jpeg']) }
        upload_photo = vk_lock { vk.photos.save_wall_photo(group_id: community.vk_id, photo: upload_file[:photo], server: upload_file[:server], hash: upload_file[:hash]) }
        upload_media.push ('photo' + upload_photo[0][:owner_id].to_s + '_' + upload_photo[0][:id].to_s)
      end
    end
    if docs.count > 0
      upload_server = vk_lock { vk.docs.get_wall_upload_server(group_id: community.vk_id) }
      docs.each do |doc|
        mime_type = MIME::Types.type_for(doc.local_filename).first.content_type
        upload_file = vk_lock { VkontakteApi.upload(url: upload_server[:upload_url], file: [(Rails.root.join('attachments', doc.local_filename).to_s), mime_type]) }
        upload_doc = vk_lock { vk.docs.save(file: upload_file[:file], title: doc.title) }
        upload_media.push ('doc' + upload_doc[0][:owner_id].to_s + '_' + upload_doc[0][:id].to_s)
      end
    end
    if upload_media.empty?
      res = vk_lock {
        vk.board.create_comment(
          group_id: community.vk_id,
          topic_id: topic.vk_id,
          message: text,
          from_group: 1
        )
      }
    else
      i = 0
      while !(chunk_media = upload_media.shift(10)).empty?
        res = vk_lock {
          vk.board.create_comment(
            group_id: community.vk_id,
            topic_id: topic.vk_id,
            message: (i == 0) ? text : '',
            attachments: chunk_media.join(','),
            from_group: 1
          )
        }
      end
    end
    copy_messages.each do |copy_message|
      copy_message.topic_id = topic.id
      copy_message.save(touch: false)
    end
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_copy_message
      @copy_message = CopyMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def copy_message_params
      params.require(:copy_message).permit(:user_vk_id, :body, :raw)
    end
end
