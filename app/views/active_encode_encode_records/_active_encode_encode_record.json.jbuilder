# frozen_string_literal: true

json.extract! active_encode_encode_record, :id, :global_id, :state, :adapter, :title, :raw_object, :created_at, :updated_at
json.url active_encode_encode_record_url(active_encode_encode_record, format: :json)
