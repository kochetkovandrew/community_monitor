class MemoryDatesController < ApplicationController
  before_action :set_memory_date, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /memory_dates
  # GET /memory_dates.json
  def index
    @memory_dates = MemoryDate.order('month asc, day asc, year asc').all
  end

  # GET /memory_dates/1
  # GET /memory_dates/1.json
  def show
  end

  # GET /memory_dates/new
  def new
    @memory_date = MemoryDate.new
  end

  # GET /memory_dates/1/edit
  def edit
  end

  # POST /memory_dates
  # POST /memory_dates.json
  def create
    @memory_date = MemoryDate.new(memory_date_params)

    respond_to do |format|
      if @memory_date.save
        format.html { redirect_to memory_dates_path, notice: 'Memory date was successfully created.' }
        format.json { render :show, status: :created, location: @memory_date }
      else
        format.html { render :new }
        format.json { render json: @memory_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memory_dates/1
  # PATCH/PUT /memory_dates/1.json
  def update
    respond_to do |format|
      if @memory_date.update(memory_date_params)
        format.html { redirect_to memory_dates_path, notice: 'Memory date was successfully updated.' }
        format.json { render :show, status: :ok, location: @memory_date }
      else
        format.html { render :edit }
        format.json { render json: @memory_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memory_dates/1
  # DELETE /memory_dates/1.json
  def destroy
    @memory_date.destroy
    respond_to do |format|
      format.html { redirect_to memory_dates_url, notice: 'Memory date was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_memory_date
      @memory_date = MemoryDate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def memory_date_params
      params.require(:memory_date).permit(:day, :month, :year, :description, :kind)
    end
end
