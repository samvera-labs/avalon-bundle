# frozen_string_literal: true
module Hyrax
  module BatchIngest
    class AudiovisualWorkItemIngester < Hyrax::BatchIngest::BatchItemIngester
      def ingest
        work = AudiovisualWork.new
        ability = ::Ability.new(::User.find_by(email: @batch_item.batch.submitter_email))
        env = Hyrax::Actors::Environment.new(work, ability, attributes)
        Hyrax::CurationConcern.actor.create(env)
        return work if work.persisted?
        raise(Hyrax::BatchIngest::IngesterError, "Work failed persisting: #{work.errors.full_messages.join(' ')}")
      end

      def attributes
        source_data = JSON.parse(@batch_item.source_data)
        fields = source_data["fields"]
        # Remove fields not present on the model
        # attrs = fields.slice(*AudiovisualWork.properties.keys)
        attrs = fields.slice(*AudiovisualWork.schema.map(&:name).map(&:to_s))
        # Make singular fields have singular values
        ['date_issued', 'physical_description', 'bibliographic_id', 'table_of_contents'].each do |field|
          attrs[field] = attrs[field].first if attrs[field].present?
        end
        # Add admin_set_id
        attrs['admin_set_id'] = @batch_item.batch.admin_set_id
        # TODO: Handle related_item and note
        # TODO: Add file metadata
        attrs
      end
    end
  end
end
