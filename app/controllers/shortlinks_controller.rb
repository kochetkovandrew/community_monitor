class ShortlinksController < ApplicationController
  before_action :set_shortlink, only: [:show, :edit, :update, :destroy]

  # GET /shortlinks
  # GET /shortlinks.json
  def index
    @shortlinks = Shortlink.all
  end

  # GET /shortlinks/1
  # GET /shortlinks/1.json
  def show
    @shortlink_histories = ShortlinkHistory.
      where(shortlink_id: @shortlink.id).
      order('created_at desc').all
  end

  # GET /shortlinks/new
  def new
    @shortlink = Shortlink.new
  end

  # GET /shortlinks/1/edit
  def edit
  end

  # POST /shortlinks
  # POST /shortlinks.json
  def create
    @shortlink = Shortlink.new(shortlink_params)

    respond_to do |format|
      if @shortlink.save
        format.html { redirect_to shortlinks_path, notice: 'Shortlink was successfully created.' }
        format.json { render :show, status: :created, location: @shortlink }
      else
        format.html { render :new }
        format.json { render json: @shortlink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shortlinks/1
  # PATCH/PUT /shortlinks/1.json
  def update
    respond_to do |format|
      if @shortlink.update(shortlink_params)
        format.html { redirect_to shortlinks_path, notice: 'Shortlink was successfully updated.' }
        format.json { render :show, status: :ok, location: @shortlink }
      else
        format.html { render :edit }
        format.json { render json: @shortlink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shortlinks/1
  # DELETE /shortlinks/1.json
  def destroy
    @shortlink.destroy
    respond_to do |format|
      format.html { redirect_to shortlinks_url, notice: 'Shortlink was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def short
    id = params[:id].to_i(36) - 1048576
    shortlink = Shortlink.find(id)
    shortlink_history = ShortlinkHistory.create(
      ip_address: request.headers.env['REMOTE_ADDR'],
      browser: request.headers.env['HTTP_USER_AGENT'],
      shortlink_id: shortlink.id,
    )
    redirect_to shortlink.link
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shortlink
      @shortlink = Shortlink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shortlink_params
      params.require(:shortlink).permit(:link, :short_link)
    end
end
