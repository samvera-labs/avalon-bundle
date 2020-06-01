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

require 'json'

# Generated via
#  `rails generate hyrax:work AudiovisualWork`
class AudiovisualWorkIndexer < Hyrax::ValkyrieWorkIndexer
  include Hyrax::Indexer(:audiovisual_work)

  def to_solr
    super.tap do |solr_doc|
      # FIXME: Should this be in the ValkyrieWorkIndexer somewhere?
      solr_doc['human_readable_type_tesim'] = resource.human_readable_type

      solr_doc['formatted_note_tesim'] = JSON.parse(resource.note).collect { |n| format_note(n) } if resource.note.present?
      solr_doc['formatted_related_item_tesim'] = JSON.parse(resource.related_item).collect { |ri| format_related_item(ri) } if resource.related_item.present?
    end
  end

  private

    def format_note(note)
      "#{Hyrax::NoteTypesService.label(note['note_type'])}: #{note['note_body']}"
    end

    def format_related_item(related_item)
      "<a href='#{related_item['related_item_url']}' target='_blank'>" \
        "<span class='glyphicon glyphicon-new-window'></span>&nbsp;" \
        "#{related_item['related_item_label']}" \
        "</a>"
    end
end
