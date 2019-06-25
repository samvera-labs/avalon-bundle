class ActiveEncodeEncodeRecordsController < ApplicationController
  before_action :set_active_encode_encode_record, only: [:show, :edit, :update, :destroy]

  # GET /active_encode_encode_records
  # GET /active_encode_encode_records.json
  def index
    @active_encode_encode_records = ActiveEncodeEncodeRecord.all
  end

  # GET /active_encode_encode_records/1
  # GET /active_encode_encode_records/1.json
  def show
  end

  # GET /active_encode_encode_records/new
  def new
    @active_encode_encode_record = ActiveEncodeEncodeRecord.new
  end

  # GET /active_encode_encode_records/1/edit
  def edit
  end

  # POST /active_encode_encode_records
  # POST /active_encode_encode_records.json
  def create
    @active_encode_encode_record = ActiveEncodeEncodeRecord.new(active_encode_encode_record_params)

    respond_to do |format|
      if @active_encode_encode_record.save
        format.html { redirect_to @active_encode_encode_record, notice: 'Active encode encode record was successfully created.' }
        format.json { render :show, status: :created, location: @active_encode_encode_record }
      else
        format.html { render :new }
        format.json { render json: @active_encode_encode_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /active_encode_encode_records/1
  # PATCH/PUT /active_encode_encode_records/1.json
  def update
    respond_to do |format|
      if @active_encode_encode_record.update(active_encode_encode_record_params)
        format.html { redirect_to @active_encode_encode_record, notice: 'Active encode encode record was successfully updated.' }
        format.json { render :show, status: :ok, location: @active_encode_encode_record }
      else
        format.html { render :edit }
        format.json { render json: @active_encode_encode_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /active_encode_encode_records/1
  # DELETE /active_encode_encode_records/1.json
  def destroy
    @active_encode_encode_record.destroy
    respond_to do |format|
      format.html { redirect_to active_encode_encode_records_url, notice: 'Active encode encode record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_active_encode_encode_record
      @active_encode_encode_record = ActiveEncodeEncodeRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def active_encode_encode_record_params
      params.require(:active_encode_encode_record).permit(:global_id, :state, :adapter, :title, :raw_object)
    end
end
