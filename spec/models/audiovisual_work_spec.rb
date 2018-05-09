# Generated via
#  `rails generate hyrax:work AudiovisualWork`
require 'rails_helper'

RSpec.describe AudiovisualWork do
  subject(:work) { build(:audiovisual_work) }

  let(:properties) do
    [:date_created,
     :license,
     :related_item,
     :identifier,
     :creator,
     :contributor,
     :publisher,
     :language,
     :date_issued,
     :abstract,
     :genre,
     :topical_subject,
     :geographic_subject,
     :temporal_subject,
     :physical_description,
     :table_of_contents,
     :note,
     :bibliographic_id,
     :local,
     :lccn,
     :issue_number,
     :matrix_number,
     :music_publisher,
     :video_recording_identifier,
     :oclc]
  end

  describe "metadata" do
    it "has Audiovisual metadata" do
      properties.each do |property|
        expect(subject).to respond_to(property)
      end
    end
  end

  describe 'to_solr' do
    let(:solr_doc) { subject.to_solr }

    let(:solr_fields) do
      ['date_created_tesim',
       'license_tesim',
       'related_item_tesim',
       'identifier_tesim',
       'creator_tesim',
       'contributor_tesim',
       'publisher_tesim',
       'language_tesim',
       'date_issued_tesim',
       'abstract_tesim',
       'genre_tesim',
       'topical_subject_tesim',
       'geographic_subject_tesim',
       'temporal_subject_tesim',
       'physical_description_tesim',
       'table_of_contents_tesim',
       'note_tesim',
       'bibliographic_id_tesim',
       'local_tesim',
       'lccn_tesim',
       'issue_number_tesim',
       'matrix_number_tesim',
       'music_publisher_tesim',
       'video_recording_identifier_tesim',
       'oclc_tesim']
    end

    it 'has solr fields' do
      solr_fields.each do |field|
        expect(solr_doc.fetch(field)).not_to be_blank
      end
    end

    it 'has human readable type' do
      expect(solr_doc.fetch('human_readable_type_tesim')).to eq 'Audiovisual Work'
    end
  end
end
