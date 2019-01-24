# frozen_string_literal: true
require 'roo'

module Hyrax
  module BatchIngest
    class AvalonBatchReader < Hyrax::BatchIngest::BatchReader
      FILE_FIELDS = [:file, :label, :offset, :skip_transcoding, :absolute_location, :date_digitized].freeze
      SKIP_FIELDS = [:collection].freeze

      protected

        def perform_read
          @spreadsheet = Roo::Spreadsheet.open(@source_location)
          @field_names = field_names
          @name = @spreadsheet.row(@spreadsheet.first_row)[0]
          @submitter_email = @spreadsheet.row(@spreadsheet.first_row)[1]
          @batch_items = []
          read_batch_items!
          raise(ReaderError, "Invalid manifest file: No batch items found") if @batch_items.empty?
        rescue StandardError => err
          raise(ReaderError, "Invalid manifest file: #{err.message}")
        ensure
          @read = true
        end

      # Deletes the batch manifest file from its source location.
      def delete_manifest
        # TODO: handle s3 case, and use URI for source_location (need to change across batch ingest gem as well)
        FileUtils.rm(@source_location, force: true)
      end

      private

        def read_batch_items!
          first = @spreadsheet.first_row + 2
          last = @spreadsheet.last_row
          first.upto(last) do |index|
            item = Hyrax::BatchIngest::BatchItem.new(id_within_batch: index.to_s, status: :initialized)
            read_batch_item!(item, index)
            @batch_items << item
          end
        end

        def read_batch_item!(item, index)
          files = []
          fields = {}
          values = @spreadsheet.row(index).map { |val| format_cell_contents(val) }
          @field_names.each_with_index do |field, i|
            add_column_to_files_and_fields!(files, fields, field, values[i]) unless field.blank? || SKIP_FIELDS.include?(field) || values[i].blank?
          end
          add_special_fields!(fields)

          all_fields = { fields: fields, files: files }
          item.source_data = all_fields.to_json
        end

        def format_cell_contents(val)
          val.is_a?(Float) && (val == val.to_i) ? val.to_i.to_s : val.to_s
        end

        def add_column_to_files_and_fields!(files, fields, field, value)
          if FILE_FIELDS.include?(field)
            case field
            when :file
              files << {}
              files.last[field] = value
            when :skip_transcoding
              files.last[field] = true?(value)
            else
              files.last[field] = value
            end
          else
            fields[field] = []
            fields[field] << value
          end
        end

        def add_special_fields!(fields)
          fields[:publish] = fields[:publish].present? ? true?(fields[:publish]) : false
          fields[:hidden] = fields[:hidden].present? ? true?(fields[:hidden]) : false
        end

        def field_names
          header_row = @spreadsheet.row(@spreadsheet.first_row + 1)
          header_row.collect { |field| field.to_s.downcase.gsub(/\s/, '_').strip.to_sym }
        rescue StandardError => err
          raise(ReaderError, "Missing header row: #{err.message}")
        end

        def true?(value)
          (value.to_s =~ /^(y(es)?|t(rue)?)$/i).present?
        end
    end
  end
end
