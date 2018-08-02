# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
# University. Additional copyright may be held by others, as reflected in
# the commit history.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

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

    def note
      solr_document.formatted_note
    end

    def related_item
      solr_document.formatted_related_item
    end

    # Override to inject work_type for proper i18n lookup
    def attribute_to_html(field, options = {})
      options[:html_dl] = true
      options[:work_type] = 'audiovisual_work'
      super
    end

    IIIF_METADATA_FIELDS = [
      :title, :creator, :rights_statement, :date_issued, :date_created, :contributor, :publisher, :abstract,
      :physical_description, :language, :genre, :topical_subject, :temporal_subject, :geographic_subject,
      :permalink, :related_item, :bibliographic_id, :local, :oclc, :lccn, :issue_number, :matrix_number,
      :music_publisher, :video_recording_identifier, :table_of_contents, :note, :license, :terms_of_use
    ].freeze

    # IIIF metadata for inclusion in the manifest (overrides Hyrax::WorkShowPresenter method)
    #  Called by the `iiif_manifest` gem to add metadata
    #
    # @return [Array] array of metadata hashes
    def manifest_metadata
      metadata = []
      IIIF_METADATA_FIELDS.each do |field|
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
