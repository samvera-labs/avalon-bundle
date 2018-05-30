# Generated via
#  `rails generate hyrax:work AudiovisualWork`
module Hyrax
  class AudiovisualWorkPresenter < Hyrax::WorkShowPresenter
    include DisplaysIIIF
    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::AVFileSetPresenter

    delegate :date_issued,
             :abstract, :physical_description, :genre,
             :topical_subject, :temporal_subject, :geographic_subject, :permalink,
             :bibliographic_id, :local, :oclc, :lccn, :issue_number, :matrix_number, :music_publisher,
             :video_recording_identifier, :table_of_contents, :terms_of_use,
             to: :solr_document

    # These two delegates will probably need to change to real methods as part of
    # https://github.com/samvera-labs/avalon-bundle/issues/119
    delegate :related_item, to: :solr_document
    delegate :note, to: :solr_document

    # IIIF metadata for inclusion in the manifest (overrides Hyrax::WorkShowPresenter method)
    #  Called by the `iiif_manifest` gem to add metadata
    #
    # @return [Array] array of metadata hashes
    def manifest_metadata
      iiif_metadata_fields = [
        :title, :creator, :rights_statement, :date_issued, :date_created, :contributor, :publisher, :abstract,
        :physical_description, :language, :genre, :topical_subject, :temporal_subject, :geographic_subject,
        :permalink, :related_item, :bibliographic_id, :local, :oclc, :lccn, :issue_number, :matrix_number,
        :music_publisher, :video_recording_identifier, :table_of_contents, :note, :license, :terms_of_use
      ]

      metadata = []
      iiif_metadata_fields.each do |field|
        value = Array.wrap(send(field))
        next if value.blank?
        metadata << {
          'label' => I18n.t("simple_form.labels.audiovisual_work.#{field}"),
          'value' => value
        }
      end
      metadata
    end
  end
end
