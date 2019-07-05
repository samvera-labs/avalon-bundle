# frozen_string_literal: true

class ActiveEncodeEncodeRecordsController < ApplicationController
  before_action :set_active_encode_encode_record, only: [:show]
  with_themed_layout 'dashboard'

  # GET /active_encode_encode_records
  # GET /active_encode_encode_records.json
  def index
    authorize! :read, :encode_dashboard
    @active_encode_encode_records = ::ActiveEncode::EncodeRecord.all
  end

  # GET /active_encode_encode_records/1
  # GET /active_encode_encode_records/1.json
  def show
    authorize! :read, :encode_dashboard
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_active_encode_encode_record
      @active_encode_encode_record = ::ActiveEncode::EncodeRecord.find(params[:id])
    end
end
