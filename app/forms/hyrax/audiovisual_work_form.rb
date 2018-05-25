# Generated via
#  `rails generate hyrax:work AudiovisualWork`
module Hyrax
  # Generated form for AudiovisualWork
  class AudiovisualWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::AudiovisualWork
    self.terms = [:title, :date_issued, :date_created, :creator, :contributor, :publisher,
                  :abstract, :physical_description, :language, :genre,
                  :topical_subject, :temporal_subject, :geographic_subject, :permalink, :related_item,
                  :bibliographic_id, :local, :oclc, :lccn, :issue_number, :matrix_number, :music_publisher, :video_recording_identifier,
                  :table_of_contents, :note, :rights_statement, :license, :terms_of_use]
    self.required_fields = [:title, :date_issued]
  end
end
