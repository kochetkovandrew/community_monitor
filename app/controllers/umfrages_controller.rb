class UmfragesController < ApplicationController
  before_action :set_umfrage, only: [:show, :edit, :update, :destroy]
  layout 'umfrage', only: [:new, :create, :vielen_dank, :index]

  # GET /umfrages
  # GET /umfrages.json
  def index
    @umfrages = Umfrage.all
  end

  # GET /umfrages/1
  # GET /umfrages/1.json
  def show
  end

  # GET /umfrages/new
  def new
    @umfrage = Umfrage.new
  end

  # GET /umfrages/1/edit
  def edit
  end

  def vielen_dank

  end

  # POST /umfrages
  # POST /umfrages.json
  def create
    @umfrage = Umfrage.new(
      result: params[:umfrage].to_json,
      ip_address: request.headers.env['REMOTE_ADDR']
    )
    respond_to do |format|
      if @umfrage.save
        format.html { redirect_to '/umfrage/vielen_dank' }
        format.json { render :show, status: :created, location: @umfrage }
      else
        format.html { render :new }
        format.json { render json: @umfrage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /umfrages/1
  # PATCH/PUT /umfrages/1.json
  def update
    respond_to do |format|
      if @umfrage.update(umfrage_params)
        format.html { redirect_to @umfrage, notice: 'Umfrage was successfully updated.' }
        format.json { render :show, status: :ok, location: @umfrage }
      else
        format.html { render :edit }
        format.json { render json: @umfrage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /umfrages/1
  # DELETE /umfrages/1.json
  def destroy
    @umfrage.destroy
    respond_to do |format|
      format.html { redirect_to umfrages_url, notice: 'Umfrage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_umfrage
      @umfrage = Umfrage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def umfrage_params
      params.require(:umfrage).permit(:result, :ip_address)
    end
end
