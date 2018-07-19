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
class AudiovisualWorkIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata

  # Uncomment this block if you want to add custom indexing behavior:
  # def generate_solr_document
  #  super.tap do |solr_doc|
  #    solr_doc['my_custom_field_ssim'] = object.my_custom_property
  #  end
  # end
  def generate_solr_document
    super.tap do |solr_doc|
      if object.note.present?
        solr_doc['formatted_note_tesim'] = JSON.parse(object.note).collect do |n|
          "#{Hyrax::NoteTypesService.label(n['note_type'])}: #{n['note_body']}"
        end
      end
      if object.related_item.present?
        solr_doc['formatted_related_item_tesim'] = JSON.parse(object.related_item).collect do |ri|
          "<a href='#{ri['related_item_url']}' target='_blank'>" +
            "<span class='glyphicon glyphicon-new-window'></span>&nbsp;" +
            "#{ri['related_item_label']}" +
          "</a>"
        end
      end
    end
  end
end
