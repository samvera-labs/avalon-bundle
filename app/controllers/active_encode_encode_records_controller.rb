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

  # POST /active_encode_encode_records/paged_index
  def paged_index
    # Encode records for index page are loaded dynamically by jquery datatables javascript which
    # requests the html for only a limited set of rows at a time.
    columns = %w[state id progress display_title file_set work_id created_at].freeze

    records_total = ::ActiveEncode::EncodeRecord.count

    # Filter
    search_value = params['search']['value']
    @encode_records = if search_value.present?
                        ::ActiveEncode::EncodeRecord.where %(
                          state ILIKE :search_value OR
                          CAST(id as varchar) ILIKE :search_value OR
                          CAST(progress as varchar) ILIKE :search_value OR
                          display_title ILIKE :search_value OR
                          file_set ILIKE :search_value OR
                          work_id ILIKE :search_value OR
                          CAST(created_at as varchar) LIKE :search_value
                        ), search_value: "%#{search_value}%"
                      else
                        ::ActiveEncode::EncodeRecord.all
                      end
    filtered_records_total = @encode_records.count

    # Sort
    sort_column = columns[params['order']['0']['column'].to_i]
    sort_direction = params['order']['0']['dir'] == 'desc' ? 'desc' : 'asc'
    @encode_records = @encode_records.order(sort_column + ' ' + sort_direction)

    # Paginate
    page_num = (params['start'].to_i / params['length'].to_i).floor + 1
    @encode_records = @encode_records.page(page_num).per(params['length'])

    response = {
      "draw": params['draw'],
      "recordsTotal": records_total,
      "recordsFiltered": filtered_records_total,
      "data": @encode_records.collect do |encode|
        encode_presenter = ActiveEncodeEncodePresenter.new(encode)
        [
          encode_presenter.status,
          view_context.link_to(encode_presenter.id, active_encode_encode_record_path(encode_presenter.id)),
          "<progress value=\"#{encode_presenter.progress}\" max=\"100\"></progress>",
          encode_presenter.title,
          view_context.link_to(encode_presenter.file_set_id, encode_presenter.file_set_url),
          view_context.link_to(encode_presenter.work_id, encode_presenter.work_url),
          encode.created_at
        ]
      end
    }
    respond_to do |format|
      format.json do
        render json: response
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_active_encode_encode_record
      @active_encode_encode_record = ::ActiveEncode::EncodeRecord.find(params[:id])
    end
end
