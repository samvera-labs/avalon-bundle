# Generated via
#  `rails generate hyrax:work AudiovisualWork`
module Hyrax
  class AudiovisualWorkPresenter < Hyrax::WorkShowPresenter
    include DisplaysIIIF

    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::AVFileSetPresenter

    delegate :date_issued,
             :abstract, :physical_description, :genre,
             :topical_subject, :temporal_subject, :geographic_subject, :permalink,
             :bibliographic_id, :local, :oclc, :lccn, :issue_number, :matrix_number, :music_publisher, :video_recording_identifier,
             :table_of_contents, :terms_of_use,
             to: :solr_document

    # These two delegates will probably need to change to real methods as part of
    # https://github.com/samvera-labs/avalon-bundle/issues/119
    delegate :related_item, to: :solr_document
    delegate :note, to: :solr_document
  end
end
