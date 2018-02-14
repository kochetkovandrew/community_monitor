class OtherDrugsController < ApplicationController
  before_action :set_other_drug, only: [:show, :edit, :update, :destroy]

  # GET /other_drugs
  # GET /other_drugs.json
  def index
    @other_drugs = OtherDrug.all
  end

  # GET /other_drugs/1
  # GET /other_drugs/1.json
  def show
  end

  # GET /other_drugs/new
  def new
    @other_drug = OtherDrug.new
  end

  # GET /other_drugs/1/edit
  def edit
  end

  # POST /other_drugs
  # POST /other_drugs.json
  def create
    @other_drug = OtherDrug.new(other_drug_params)

    respond_to do |format|
      if @other_drug.save
        format.html { redirect_to @other_drug, notice: 'Other drug was successfully created.' }
        format.json { render :show, status: :created, location: @other_drug }
      else
        format.html { render :new }
        format.json { render json: @other_drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /other_drugs/1
  # PATCH/PUT /other_drugs/1.json
  def update
    respond_to do |format|
      if @other_drug.update(other_drug_params)
        format.html { redirect_to @other_drug, notice: 'Other drug was successfully updated.' }
        format.json { render :show, status: :ok, location: @other_drug }
      else
        format.html { render :edit }
        format.json { render json: @other_drug.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /other_drugs/1
  # DELETE /other_drugs/1.json
  def destroy
    @other_drug.destroy
    respond_to do |format|
      format.html { redirect_to other_drugs_url, notice: 'Other drug was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_other_drug
      @other_drug = OtherDrug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def other_drug_params
      params.require(:other_drug).permit(:name)
    end
end
