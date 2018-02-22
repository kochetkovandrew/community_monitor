class CopyMessagesController < ApplicationController
  before_action :set_copy_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action { |f| f.require_permission! 'Detective' }

  # GET /copy_messages
  # GET /copy_messages.json
  def index
    @copy_messages = CopyMessage.all
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
