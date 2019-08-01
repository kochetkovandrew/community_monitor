class PortalAttachmentsController < ApplicationController
  before_action :set_portal_attachment, only: [:show, :edit, :update, :destroy]

  # GET /portal_attachments
  # GET /portal_attachments.json
  def index
    @portal_attachments = PortalAttachment.all
    @portal_attachment = PortalAttachment.new
  end

  # GET /portal_attachments/1
  # GET /portal_attachments/1.json
  def show
  end

  # GET /portal_attachments/new
  def new
    @portal_attachment = PortalAttachment.new
  end

  # GET /portal_attachments/1/edit
  def edit
  end

  # POST /portal_attachments
  # POST /portal_attachments.json
  def create
    @portal_attachment = PortalAttachment.new(portal_attachment_params)

    respond_to do |format|
      if @portal_attachment.save
        format.html { redirect_to @portal_attachment, notice: 'Portal attachment was successfully created.' }
        format.json { render :show, status: :created, location: @portal_attachment }
      else
        format.html { render :new }
        format.json { render json: @portal_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portal_attachments/1
  # PATCH/PUT /portal_attachments/1.json
  def update
    respond_to do |format|
      if @portal_attachment.update(portal_attachment_params)
        format.html { redirect_to @portal_attachment, notice: 'Portal attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @portal_attachment }
      else
        format.html { render :edit }
        format.json { render json: @portal_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portal_attachments/1
  # DELETE /portal_attachments/1.json
  def destroy
    @portal_attachment.destroy
    respond_to do |format|
      format.html { redirect_to portal_attachments_url, notice: 'Portal attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_portal_attachment
      @portal_attachment = PortalAttachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def portal_attachment_params
      params.require(:portal_attachment).permit(:filename, :guid)
    end
end
