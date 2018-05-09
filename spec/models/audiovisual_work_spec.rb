# Generated via
#  `rails generate hyrax:work AudiovisualWork`
require 'rails_helper'

RSpec.describe AudiovisualWork do

  describe "metadata" do
    it "has Audiovisual metadata" do
      expect(subject).to respond_to(:date_created)
      expect(subject).to respond_to(:terms_of_use)
      expect(subject).to respond_to(:related_item_url)
      expect(subject).to respond_to(:permalink)

      expect(subject).to respond_to(:creator)
      expect(subject).to respond_to(:contributor)
      expect(subject).to respond_to(:publisher)
      expect(subject).to respond_to(:language)

      expect(subject).to respond_to(:date_issued)
      expect(subject).to respond_to(:abstract)
      expect(subject).to respond_to(:genre)
      expect(subject).to respond_to(:topical_subject)
      expect(subject).to respond_to(:geographic_subject)
      expect(subject).to respond_to(:temporal_subject)
      expect(subject).to respond_to(:physical_description)
      expect(subject).to respond_to(:table_of_contents)
      expect(subject).to respond_to(:note)
      expect(subject).to respond_to(:related_item_url)
      expect(subject).to respond_to(:bibliographic_id)
      expect(subject).to respond_to(:local)
      expect(subject).to respond_to(:lccn)
      expect(subject).to respond_to(:issue_number)
      expect(subject).to respond_to(:matrix_number)
      expect(subject).to respond_to(:music_publisher)
      expect(subject).to respond_to(:video_recording_identifier)
      expect(subject).to respond_to(:oclc)
    end
  end

  describe 'to_solr' do
    let(:indexer) { double(generate_solr_document: {}) }

    before do
      allow(Hyrax::FileSetIndexer).to receive(:new).with(subject).and_return(indexer)
    end

    it 'calls the indexer' do
      expect(indexer).to receive(:generate_solr_document)
      subject.to_solr
    end

    it 'has human readable type' do
      expect(subject.to_solr.fetch('human_readable_type_tesim')).to eq 'Audio Visual Work'
    end
  end

end
