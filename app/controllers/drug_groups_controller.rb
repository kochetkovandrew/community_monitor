class DrugGroupsController < ApplicationController
  before_action :set_drug_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /drug_groups
  # GET /drug_groups.json
  def index
    @drug_groups = DrugGroup.all
  end

  # GET /drug_groups/1
  # GET /drug_groups/1.json
  def show
  end

  # GET /drug_groups/new
  def new
    @drug_group = DrugGroup.new
  end

  # GET /drug_groups/1/edit
  def edit
  end

  # POST /drug_groups
  # POST /drug_groups.json
  def create
    @drug_group = DrugGroup.new(drug_group_params)

    respond_to do |format|
      if @drug_group.save
        format.html { redirect_to @drug_group, notice: 'Drug group was successfully created.' }
        format.json { render :show, status: :created, location: @drug_group }
      else
        format.html { render :new }
        format.json { render json: @drug_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drug_groups/1
  # PATCH/PUT /drug_groups/1.json
  def update
    respond_to do |format|
      if @drug_group.update(drug_group_params)
        format.html { redirect_to @drug_group, notice: 'Drug group was successfully updated.' }
        format.json { render :show, status: :ok, location: @drug_group }
      else
        format.html { render :edit }
        format.json { render json: @drug_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drug_groups/1
  # DELETE /drug_groups/1.json
  def destroy
    @drug_group.destroy
    respond_to do |format|
      format.html { redirect_to drug_groups_url, notice: 'Drug group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_drug_group
      @drug_group = DrugGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def drug_group_params
      params.require(:drug_group).permit(:name, :translation)
    end
end
