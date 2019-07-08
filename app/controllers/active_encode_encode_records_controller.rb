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
    @encode_records = ::ActiveEncode::EncodeRecord.all
    recordsTotal = @encode_records.count
    columns = ['status','id','progress','title','fileset_url','work_url','started']

    # Create array of records as presented in the UI for sorting and filtering
    @encode_records = @encode_records.collect do |encode|
      encode_presenter = ActiveEncodeEncodePresenter.new(encode)
      [
        encode_presenter.status,
        encode_presenter.id,
        encode_presenter.progress,
        encode_presenter.title,
        encode_presenter.file_set_id,
        encode_presenter.work_id,
        encode_presenter.started,
        encode_presenter
      ]
    end

    # Filter
    filter = params['search']['value']
    if filter.present?
      pattern = Regexp.new filter
      @encode_records.select! { |e| e.select { |v| pattern =~ v.to_s }.present? }
    end

    # Sort: decorate list with sort column then sort and undecorate
    sort_column = params['order']['0']['column'].to_i rescue 0
    sort_direction = params['order']['0']['dir'] rescue 'asc'
    decorated = @encode_records.collect { |e| [ e[sort_column], e ] }
    decorated.sort!
    @encode_records = decorated.collect { |e| e[1] }
    @encode_records.reverse! if sort_direction != 'asc'

    # Paginate
    @encode_records = @encode_records.slice(params['start'].to_i, params['length'].to_i)

    response = {
      "draw": params['draw'],
      "recordsTotal": recordsTotal,
      "recordsFiltered": @encode_records.count,
      "data": @encode_records.collect do |encode|
        encode_presenter = encode[7]
        [
          encode_presenter.status,
          view_context.link_to(encode_presenter.id,  active_encode_encode_record_path(encode_presenter.id)),
          "<progress value=\"#{encode_presenter.progress}\" max=\"100\"></progress>",
          encode_presenter.title,
          view_context.link_to(encode_presenter.file_set_id, encode_presenter.file_set_url),
          view_context.link_to(encode_presenter.work_id, encode_presenter.work_url),
          encode_presenter.started
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
