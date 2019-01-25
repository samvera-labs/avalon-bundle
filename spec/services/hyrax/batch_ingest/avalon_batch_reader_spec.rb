# frozen_string_literal: true
require 'rails_helper'
require 'cancan/matchers'
require 'hyrax/batch_ingest/spec/shared_specs'

describe Hyrax::BatchIngest::AvalonBatchReader do
  let(:reader_class) { described_class }
  let(:source_location) { "spec/fixtures/valid_manifest.csv" }
  let(:invalid_source_location) { "spec/fixtures/invalid_csv.csv" }

  it_behaves_like 'a Hyrax::BatchIngest::BatchReader'

  describe '#submitter_email' do
    let(:reader) { described_class.new(source_location) }

    it 'returns the submitter email' do
      expect(reader.submitter_email).to eq 'archivist1@example.com'
    end
  end

  describe '#batch_items' do
    let(:reader) { described_class.new(source_location) }
    let(:batch_item) { reader.batch_items.first }
    let(:source_data) { JSON.parse(batch_item.source_data) }
    let(:fields) do
      { "bibliographic_id_label" => ["Catalog Key"], "bibliographic_id" => ["3671440"],
        "other_identifier_type" => ["OCLC"], "other_identifier" => ["39096003"],
        "title" => ["lroom"], "creator" => ["I"], "contributor" => ["saidulla"],
        "publisher" => ["lroompubs"], "date_issued" => ["1990"],
        "topical_subject" => ["Social engineering"], "publish" => false, "hidden" => false }
    end
    let(:files) { [{ "file" => "assets/lunchroom_manners.mp4", "label" => "lunchroom", "skip_transcoding" => true }] }

    it 'includes all fields' do
      expect(source_data["fields"]).to eq fields
    end

    it 'includes all files' do
      expect(source_data["files"]).to eq files
    end
  end

  describe '#delete_manifest' do
    let(:source_location) { 'dropbox/TestAdminSet/manifest.csv' }
    let(:reader) { described_class.new(source_location) }

    before do
      FakeFS.activate!
      FileUtils.mkdir_p(File.dirname(source_location))
      FileUtils.touch(source_location)
    end

    after do
      FakeFS.deactivate!
    end

    it 'deletes the manifest file' do
      reader.delete_manifest
      expect(File.exist?(source_location)).to be false
    end
  end
end
