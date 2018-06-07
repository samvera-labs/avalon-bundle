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

require 'rails_helper'

RSpec.describe Hyrax::AVFileSetPresenter do
  let(:id) { '12345' }
  let(:solr_document) { SolrDocument.new(id: id) }
  let(:request) { instance_double("Request", base_url: 'http://test.host') }
  let(:ability) { instance_double("Ability") }
  let(:presenter) { described_class.new(solr_document, ability, request) }
  let(:read_permission) { true }
  let(:parent_presenter) { instance_double("Hyrax::GenericWorkPresenter", iiif_version: 2) }
  let(:first_title) { 'File Set Title' }
  let(:title) { [first_title] }

  before do
    allow(ability).to receive(:can?).with(:read, solr_document.id).and_return(read_permission)
    allow(presenter).to receive(:parent).and_return(parent_presenter)
    allow(presenter).to receive(:title).and_return(title)
  end

  describe '#display_content' do
    it 'responds to #display_content' do
      expect(presenter.respond_to?(:display_content)).to be true
    end

    subject { presenter.display_content }

    context 'without a file' do
      let(:id) { 'bogus' }

      it { is_expected.to be_nil }
    end

    context 'with a file' do
      context "when the file is not a known file" do
        it { is_expected.to be_nil }
      end

      context "when the file is a sound recording" do
        let(:solr_document) { SolrDocument.new(id: '12345', duration_tesim: 1000) }
        let(:mp3_url) { "http://test.host/downloads/#{solr_document.id}?file=mp3" }
        let(:ogg_url) { "http://test.host/downloads/#{solr_document.id}?file=ogg" }

        before do
          allow(solr_document).to receive(:audio?).and_return(true)
        end

        it 'creates an array of content objects' do
          expect(subject).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(subject.length).to eq 2
          expect(subject.map(&:type)).to all(eq 'Sound')
          expect(subject.map(&:duration)).to all(eq 1.000)
          expect(subject.map(&:url)).to match_array([mp3_url, ogg_url])
        end
      end

      context "when the file is a video" do
        let(:solr_document) { SolrDocument.new(id: '12345', width_is: 640, height_is: 480, duration_tesim: 1000) }
        let(:mp4_url) { "http://test.host/downloads/#{id}?file=mp4" }
        let(:webm_url) { "http://test.host/downloads/#{id}?file=webm" }

        before do
          allow(solr_document).to receive(:video?).and_return(true)
        end

        # rubocop:disable RSpec/ExampleLength
        it 'creates an array of content objects' do
          expect(subject).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(subject.length).to eq 2
          expect(subject.map(&:type)).to all(eq 'Video')
          expect(subject.map(&:width)).to all(eq 640)
          expect(subject.map(&:height)).to all(eq 480)
          expect(subject.map(&:duration)).to all(eq 1.000)
          expect(subject.map(&:url)).to match_array([mp4_url, webm_url])
        end
        # rubocop:enable RSpec/ExampleLength
      end

      context 'when the file is an audio derivative with metadata' do
        let(:files_metadata) do
          [
            { id: '1', label: 'high', external_file_uri: 'http://test.com/high.mp3' },
            { id: '2', label: 'medium', external_file_uri: 'http://test.com/medium.mp3' }
          ]
        end
        let(:solr_document) { SolrDocument.new(id: '12345', duration_tesim: 1000, files_metadata_ssi: files_metadata.to_json) }

        before do
          allow(solr_document).to receive(:audio?).and_return(true)
        end

        it 'creates an array of content objects with metadata' do
          expect(subject).to all(be_instance_of IIIFManifest::V3::DisplayContent)
          expect(subject.length).to eq 2
          expect(subject.map(&:label)).to match_array(['high', 'medium'])
          expect(subject.map(&:url)).to match_array(['http://test.com/high.mp3', 'http://test.com/medium.mp3'])
        end
      end

      context "when the file is an image" do
        before do
          allow(solr_document).to receive(:image?).and_return(true)
        end

        it 'creates a content object' do
          expect(subject).to be_instance_of IIIFManifest::DisplayImage
          expect(subject.url).to eq "http://test.host/images/#{id}/full/600,/0/default.jpg"
        end

        context 'with custom image size default' do
          let(:custom_image_size) { '666,' }

          around do |example|
            default_image_size = Hyrax.config.iiif_image_size_default
            Hyrax.config.iiif_image_size_default = custom_image_size
            example.run
            Hyrax.config.iiif_image_size_default = default_image_size
          end

          it 'creates a content object' do
            expect(subject).to be_instance_of IIIFManifest::DisplayImage
            expect(subject.url).to eq "http://test.host/images/#{id}/full/#{custom_image_size}/0/default.jpg"
          end
        end

        context 'with custom image url builder' do
          let(:custom_builder) do
            ->(file_id, base_url, _size) { "#{base_url}/downloads/#{file_id.split('/').first}" }
          end

          around do |example|
            default_builder = Hyrax.config.iiif_image_url_builder
            Hyrax.config.iiif_image_url_builder = custom_builder
            example.run
            Hyrax.config.iiif_image_url_builder = default_builder
          end

          it 'creates a content object' do
            expect(subject).to be_instance_of IIIFManifest::DisplayImage
            expect(subject.url).to eq "http://test.host/downloads/#{id.split('/').first}"
          end
        end

        context "when the user doesn't have permission to view the image" do
          let(:read_permission) { false }

          it { is_expected.to be_nil }
        end

        context "when the parent presenter's iiif_version is 3" do
          let(:parent_presenter) { instance_double("Hyrax::GenericWorkPresenter", iiif_version: 3) }

          it 'creates a V3 content object' do
            expect(subject).to be_instance_of IIIFManifest::V3::DisplayContent
            expect(subject.url).to eq "http://test.host/images/#{id}/full/600,/0/default.jpg"
          end
        end
      end
    end
  end

  describe '#range' do
    let(:structure_tesim) { nil }
    let(:solr_document) { SolrDocument.new(id: id, structure_tesim: structure_tesim) }

    it 'responds to #range' do
      expect(presenter.respond_to?(:range)).to be true
    end

    subject { presenter.range }

    context 'without structure' do
      let(:media_fragment) { 't=0,' }
      it 'returns a simple range' do
        expect(subject.label).to eq first_title
        expect(subject.items.first.media_fragment).to eq media_fragment
      end
    end

    # TODO
#     context 'with empty structure' do
#       let(:structure_tesim) do
#         '<?xml version="1.0" encoding="UTF-8"?>
# <Item label="Test Label">
# </Item>'
#     end

    context 'with valid structure' do
      let(:structure_tesim) do
        '<?xml version="1.0" encoding="UTF-8"?>
<Item label="Root 0">
    <Span label="Span 0.1" begin="0:00:00" end="0:01:00"/>
    <Div label="Div 0.2">
        <Span label="Span 0.2.1 begin="0:01:01" end="0:02.00"/>
        <Span label="Span 0.2.2 begin="0:02:01" end="0:03.00"/>
    </Div>
</Item>'
      end

      it 'returns a hierarchy of ranges/canvases' do
        expect(subject.label['@none'.to_sym]).to eq 'Root 0'
        expect(subject.items.first.label).to eq 'Span 0.1'
        expect(subject.items.first.media_fragment).to eq '0,60'
        expect(subject.items.second.label).to eq 'Div 0.2'
        expect(subject.items.second.items.first.label).to eq 'Span 0.2.1'
        expect(subject.items.second.items.first.media_fragment).to eq '61,120'
        expect(subject.items.second.items.second.label).to eq 'Span 0.2.2'
        expect(subject.items.second.items.second.media_fragment).to eq '121,180'
      end
    end
  end
end
