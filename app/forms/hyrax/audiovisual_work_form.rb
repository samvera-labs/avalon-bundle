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
  # Generated form for AudiovisualWork
  class AudiovisualWorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::AudiovisualWork
    self.terms = [:title, :date_issued, :date_created, :creator, :contributor, :publisher,
                  :abstract, :physical_description, :language, :genre,
                  :topical_subject, :temporal_subject, :geographic_subject, :permalink, :related_item,
                  :bibliographic_id, :local, :oclc, :lccn, :issue_number, :matrix_number, :music_publisher, :video_recording_identifier,
                  :table_of_contents, :note, :rights_statement, :license, :terms_of_use]
    self.required_fields = [:title, :date_issued]

    # Transient fields to make SimpleForm happy
    attr_accessor :note_type, :note_body
    def notes_with_types
      # Parse json from note
      return [] if note.blank?
      JSON.parse(note).collect { |n| [n['note_type'], n['note_body']] }
    end

    attr_accessor :related_item_url, :related_item_label
    def related_items_with_labels
      # Parse json from related_item
      return [] if related_item.blank?
      JSON.parse(related_item).collect { |ri| [ri['related_item_label'], ri['related_item_url']] }
    end
  end
end
