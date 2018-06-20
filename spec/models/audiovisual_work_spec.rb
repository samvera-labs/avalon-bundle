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

RSpec.describe AudiovisualWork do
  subject(:work) { build(:audiovisual_work) }

  let(:properties) do
    [:title,
     :date_issued,
     :date_created,
     :creator,
     :contributor,
     :publisher,
     :abstract,
     :physical_description,
     :language,
     :genre,
     :topical_subject,
     :temporal_subject,
     :geographic_subject,
     :permalink,
     :related_item,
     :bibliographic_id,
     :local,
     :oclc,
     :lccn,
     :issue_number,
     :matrix_number,
     :music_publisher,
     :video_recording_identifier,
     :table_of_contents,
     :note,
     :rights_statement,
     :license,
     :terms_of_use]
  end

  describe "metadata" do
    it "has Audiovisual metadata" do
      properties.each do |property|
        expect(subject).to respond_to(property)
      end
    end
  end

  describe 'validations' do
    it 'validates presence of title' do
      expect(subject).to validate_presence_of(:title).with_message('Your work must have a title.')
    end
    it 'validates presence of date issued' do
      expect(subject).to validate_presence_of(:date_issued).with_message('Your work must have date issued.')
    end
  end

  describe 'to_solr' do
    let(:solr_doc) { subject.to_solr }

    let(:solr_fields) do
      [:title_tesim,
       :date_issued_tesim,
       :date_created_tesim,
       :creator_tesim,
       :contributor_tesim,
       :publisher_tesim,
       :abstract_tesim,
       :physical_description_tesim,
       :language_tesim,
       :genre_tesim,
       :topical_subject_tesim,
       :temporal_subject_tesim,
       :geographic_subject_tesim,
       :permalink_tesim,
       :related_item_tesim,
       :bibliographic_id_tesim,
       :local_tesim,
       :oclc_tesim,
       :lccn_tesim,
       :issue_number_tesim,
       :matrix_number_tesim,
       :music_publisher_tesim,
       :video_recording_identifier_tesim,
       :table_of_contents_tesim,
       :note_ssm,
       :rights_statement_tesim,
       :license_tesim,
       :terms_of_use_tesim,
       :formatted_note_tesim]
    end

    it 'has solr fields' do
      solr_fields.each do |field|
        expect(solr_doc.fetch(field.to_s)).not_to be_blank
      end
    end

    it 'has human readable type' do
      expect(solr_doc.fetch('human_readable_type_tesim')).to eq 'Audiovisual Work'
    end

    it 'has a formatted note' do
      expect(solr_doc.fetch('formatted_note_tesim')).to eq ['Statement of Responsibility: Jane Doe / Title']
    end
  end
end
