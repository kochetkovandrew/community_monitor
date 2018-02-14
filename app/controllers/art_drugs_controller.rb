class ArtDrugsController < ApplicationController
  before_action :set_art_drug, only: [:show, :edit, :update, :destroy]

  # GET /art_drugs
  # GET /art_drugs.json
  def index
    @art_drugs = ArtDrug.all
  end

  # GET /art_drugs/1
  # GET /art_drugs/1.json
  def show
  end

  # GET /art_drugs/new
  def new
    @art_drug = ArtDrug.new
  end

  # GET /art_drugs/1/edit
  def edit
  end

  # POST /art_drugs
  # POST /art_drugs.json
  def create
    @art_drug = ArtDrug.new(art_drug_params)

    respond_to do |format|
      if @art_drug.save
        format.html { redirect_to @art_drug, notice: 'Art drug was successfully created.' }
        format.json { render :show, status: :created, location: @art_drug }
      else
        format.html { render :new }
        format.json { render json: @art_drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /art_drugs/1
  # PATCH/PUT /art_drugs/1.json
  def update
    respond_to do |format|
      if @art_drug.update(art_drug_params)
        format.html { redirect_to @art_drug, notice: 'Art drug was successfully updated.' }
        format.json { render :show, status: :ok, location: @art_drug }
      else
        format.html { render :edit }
        format.json { render json: @art_drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /art_drugs/1
  # DELETE /art_drugs/1.json
  def destroy
    @art_drug.destroy
    respond_to do |format|
      format.html { redirect_to art_drugs_url, notice: 'Art drug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_art_drug
      @art_drug = ArtDrug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def art_drug_params
      params.require(:art_drug).permit([:name, :translation])
    end
end
