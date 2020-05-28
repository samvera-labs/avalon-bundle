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
require 'rails_helper'

RSpec.describe AudiovisualWorkIndexer do
  let(:work) { build(:audiovisual_work) }
  subject(:indexer) { described_class.new(resource: work) }

  describe 'to_solr' do
    let(:solr_doc) { subject.to_solr }

    let(:solr_fields) do
      [:title_tesim,
       :title_sim,
       :date_issued_tesi,
       :date_created_tesim,
       :creator_tesim,
       :contributor_tesim,
       :publisher_tesim,
       :abstract_tesim,
       :physical_description_tesi,
       :language_tesim,
       :genre_tesim,
       :topical_subject_tesim,
       :temporal_subject_tesim,
       :geographic_subject_tesim,
       :permalink_tesim,
       :related_item_tesi,
       :bibliographic_id_tesi,
       :local_tesim,
       :oclc_tesim,
       :lccn_tesim,
       :issue_number_tesim,
       :matrix_number_tesim,
       :music_publisher_tesim,
       :video_recording_identifier_tesim,
       :table_of_contents_tesi,
       :note_ss,
       :rights_statement_tesi,
       :license_tesim,
       :terms_of_use_tesim,
       'formatted_note_tesim']
    end

    it 'has solr fields' do
      solr_fields.each do |field|
        # FIXME: The indexer is returning symbols in the solr_doc instead of strings
        expect(solr_doc.fetch(field)).not_to be_blank
      end
    end

    it 'has human readable type' do
      expect(solr_doc.fetch('human_readable_type_tesim')).to eq 'Audiovisual Work'
    end

    it 'has a formatted note' do
      expect(solr_doc.fetch('formatted_note_tesim')).to eq ['Statement of Responsibility: Jane Doe / Title']
    end

    it 'has a formatted related_item' do
      expect(solr_doc.fetch('formatted_related_item_tesim')).to eq(
        ["<a href='http://example.com/another-resource' target='_blank'><span class='glyphicon glyphicon-new-window'></span>&nbsp;Another Resource</a>"]
      )
    end
  end
end
