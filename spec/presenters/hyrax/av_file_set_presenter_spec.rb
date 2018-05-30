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
  let(:solr_document) { SolrDocument.new(id: '12345') }
  let(:request) { instance_double("Request", base_url: 'http://test.host') }
  let(:ability) { instance_double("Ability") }
  let(:presenter) { described_class.new(solr_document, ability, request) }
  let(:read_permission) { true }
  let(:id) { solr_document.id }
  let(:parent_presenter) { instance_double("Hyrax::GenericWorkPresenter", iiif_version: 2) }

  before do
    allow(ability).to receive(:can?).with(:read, solr_document.id).and_return(read_permission)
    allow(presenter).to receive(:parent).and_return(parent_presenter)
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
end
