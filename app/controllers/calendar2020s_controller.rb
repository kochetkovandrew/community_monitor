class Calendar2020sController < ApplicationController

  layout 'blank', only: [:vk_index]

  before_action :set_calendar2020, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:vk_index]
  after_action :allow_iframe, only: [:vk_index]

  # GET /calendar2020s
  # GET /calendar2020s.json
  def index
    @calendar2020s = Calendar2020.all
  end

  # GET /calendar2020s/1
  # GET /calendar2020s/1.json
  def show
  end

  def vk_index
    @calendar2020s = Calendar2020.all
  end

  # GET /calendar2020s/new
  def new
    @calendar2020 = Calendar2020.new
  end

  # GET /calendar2020s/1/edit
  def edit
    @calendar2020 = Calendar2020.where(day: params[:day]).first
    @calendar2020 ||= Calendar2020.new(day: params[:day])
  end

  # POST /calendar2020s
  # POST /calendar2020s.json
  def create
    @calendar2020 = Calendar2020.new(calendar2020_params)

    respond_to do |format|
      if @calendar2020.save
        format.html { redirect_to calendar2020s_path, notice: 'Calendar2020 was successfully created.' }
        format.json { render :show, status: :created, location: @calendar2020 }
      else
        format.html { render :new }
        format.json { render json: @calendar2020.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendar2020s/1
  # PATCH/PUT /calendar2020s/1.json
  def update
    p params
    respond_to do |format|
      if @calendar2020.update(calendar2020_params)

        uploaded_io = params[:calendar2020][:picture]
        if !uploaded_io.nil?
          suffix = File.extname(uploaded_io.original_filename)
          File.open(Rails.root.join('public', 'images', 'calendar', @calendar2020.day.to_s + suffix), 'wb') do |file|
            file.write(uploaded_io.read)
          end
        end
        @calendar2020.has_picture = true
        @calendar2020.save


        format.html { redirect_to calendar2020s_path, notice: 'Calendar2020 was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar2020 }
      else
        format.html { render :edit }
        format.json { render json: @calendar2020.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendar2020s/1
  # DELETE /calendar2020s/1.json
  def destroy
    @calendar2020.destroy
    respond_to do |format|
      format.html { redirect_to calendar2020s_url, notice: 'Calendar2020 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_calendar2020
    @calendar2020 = Calendar2020.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def calendar2020_params
    params.require(:calendar2020).permit(:day, :description, :header, :footer)
  end

  def allow_iframe
    response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://api.vk.com"
    response.headers.delete_if{|key| key.upcase=='X-FRAME-OPTIONS'}
  end

end
