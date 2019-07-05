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
require 'hyrax/iiif_av/spec/shared_specs'

RSpec.describe Hyrax::AVFileSetPresenter do
  # HACK: To deal with inconsistencies between hyrax-iiif_av's expected generated urls and avalon-bundle's configured generator
  around do |example|
    original_builder = Hyrax.config.iiif_image_url_builder
    default_builder = ->(file_id, base_url, size) { "#{base_url}/#{file_id}/full/#{size}/0/default.jpg" }
    Hyrax.config.iiif_image_url_builder = default_builder
    example.run
    Hyrax.config.iiif_image_url_builder = original_builder
  end

  it_behaves_like 'IiifAv::DisplaysContent'

  let(:id) { '12345' }
  let(:solr_document) { SolrDocument.new(id: id) }
  let(:request) { instance_double("Request", base_url: 'http://test.host') }
  let(:ability) { instance_double("Ability") }
  let(:presenter) { described_class.new(solr_document, ability, request) }
  let(:first_title) { 'File Set Title' }
  let(:title) { [first_title] }

  before do
    allow(presenter).to receive(:title).and_return(title)
  end

  describe '#encode_record' do
    subject { presenter.encode_record }
    let(:encode_global_id) { 'gid://ActiveEncode/ActiveEncode::Base/1' }
    let(:solr_document) { SolrDocument.new(id: id, encode_global_id_ssim: [encode_global_id]) }

    it 'responds to #encode_record' do
      expect(presenter.respond_to?(:encode_record)).to be true
    end

    context 'without global id' do
      let(:solr_document) { SolrDocument.new(id: id, encode_global_id_ssim: nil) }

      it { is_expected.to be_nil }
    end

    context 'when encode record does not exist' do
      let(:encode_global_id) { 'gid://ActiveEncode/ActiveEncode::Base/non-existant' }

      it { is_expected.to be_nil }
    end

    context 'when encode record exists' do
      before do
        ActiveEncode::EncodeRecord.create(global_id: encode_global_id)
      end

      it { is_expected.to be_a ActiveEncodeEncodePresenter }
    end
  end

  describe '#range' do
    subject { presenter.range }
    let(:structure_tesim) { nil }
    let(:solr_document) { SolrDocument.new(id: id, structure_tesim: [structure_tesim]) }

    it 'responds to #range' do
      expect(presenter.respond_to?(:range)).to be true
    end

    context 'without structure' do
      let(:solr_document) { SolrDocument.new(id: id, structure_tesim: nil) }
      let(:media_fragment) { 't=0,' }

      it 'returns a simple range' do
        expect(subject.label['@none'.to_sym].first).to eq first_title
        expect(subject.items.first.media_fragment).to eq media_fragment
      end
    end

    context 'with empty structure' do
      let(:structure_tesim) { '' }
      let(:media_fragment) { 't=0,' }

      it 'returns a simple range' do
        expect(subject.label['@none'.to_sym].first).to eq first_title
        expect(subject.items.first.media_fragment).to eq media_fragment
      end
    end

    context 'with invalid structure' do
      let(:structure_tesim) do
        '<?xml version="1.0" encoding="UTF-8"?>
<Item label="Test Label">
</Item>'
      end
      let(:error) { Nokogiri::XML::SyntaxError }
      let(:errmsg) { "Empty root or Div node: Test Label" }

      it 'raises SyntaxError' do
        expect { subject }.to raise_error(error, errmsg)
      end
    end

    context 'with valid structure' do
      let(:structure_tesim) do
        '<?xml version="1.0" encoding="UTF-8"?>
<Item label="Root 0">
    <Span label="Span 0.1" begin="0:00:00" end="0:01:00"/>
    <Div label="Div 0.2">
        <Span label="Span 0.2.1" begin="0:01:01" end="0:02:00"/>
        <Span label="Span 0.2.2" begin="0:02:01" end="0:03:00"/>
    </Div>
</Item>'
      end

      it 'returns a hierarchy of ranges/canvases' do
        expect(subject.label['@none'.to_sym].first).to eq 'Root 0'
        expect(subject.items.first.label['@none'.to_sym].first).to eq 'Span 0.1'
        expect(subject.items.first.items.first.media_fragment).to eq 't=0.0,60.0'
        expect(subject.items.second.label['@none'.to_sym].first).to eq 'Div 0.2'
        expect(subject.items.second.items.first.label['@none'.to_sym].first).to eq 'Span 0.2.1'
        expect(subject.items.second.items.first.items.first.media_fragment).to eq 't=61.0,120.0'
        expect(subject.items.second.items.second.label['@none'.to_sym].first).to eq 'Span 0.2.2'
        expect(subject.items.second.items.second.items.first.media_fragment).to eq 't=121.0,180.0'
      end
    end
  end
end
