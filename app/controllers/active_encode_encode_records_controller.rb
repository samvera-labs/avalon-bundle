class ActiveEncodeEncodeRecordsController < ApplicationController
  before_action :set_active_encode_encode_record, only: [:show]

  # GET /active_encode_encode_records
  # GET /active_encode_encode_records.json
  def index
    @active_encode_encode_records = ::ActiveEncode::EncodeRecord.all
  end

  # GET /active_encode_encode_records/1
  # GET /active_encode_encode_records/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_active_encode_encode_record
      @active_encode_encode_record = ::ActiveEncode::EncodeRecord.find(params[:id])
    end
end
