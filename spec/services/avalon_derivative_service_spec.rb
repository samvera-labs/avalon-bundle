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
require 'hyrax/specs/shared_specs'

RSpec.describe AvalonDerivativeService, clean_repo: true do
  before(:all) do
    class CustomOptionService
      def self.call(_file_set)
        [{ foo: 'bar' }]
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :CustomOptionService)
  end

  before do
    allow(file_set).to receive(:parent).and_return(work)
  end

  let(:file_set) { create(:file_set) }
  let(:work) { create(:work) }
  let(:encode_class) { ::ActiveEncode::Base }
  let(:options_service_class) { Hyrax::ActiveEncode::DefaultOptionService }
  let(:service) { described_class.new(file_set, encode_class: encode_class, options_service_class: options_service_class) }

  it_behaves_like "a Hyrax::DerivativeService"

  describe '#valid?' do
    subject { service.valid? }

    context 'all supported mime types' do
      let(:supported_mime_types) { service.send(:supported_mime_types) }

      it 'supports expected mime types' do
        supported_mime_types.each do |mime|
          file_set = FileSet.new
          allow(file_set).to receive(:mime_type).and_return(mime)
          expect(described_class.new(file_set).valid?).to be true
        end
      end
    end

    context 'with video original file' do
      before do
        allow(file_set).to receive(:mime_type).and_return('video/mp4')
      end

      it { is_expected.to be true }
    end

    context 'with audio original file' do
      before do
        allow(file_set).to receive(:mime_type).and_return('audio/wav')
      end

      it { is_expected.to be true }
    end

    context 'with non-AV original file' do
      before do
        allow(file_set).to receive(:mime_type).and_return('application/pdf')
      end

      it { is_expected.to be false }
    end
  end

  describe '#create_derivatives' do
    let(:options) { options_service_class.call(file_set) }
    let(:outputs) { options.map { |o| o.merge(internal_options) } }
    let(:derivative_url) { service.send(:derivative_url, 'high') }

    before do
      allow(Hydra::Derivatives::VideoDerivatives).to receive(:create)
    end

    context 'with local streaming' do
      let(:internal_options) { { file_set_id: file_set.id, local_streaming: true } }

      it 'calls the ActiveEncode runner with the original file, passing the encode class and the provided output options' do
        allow(Hydra::Derivatives::ActiveEncodeDerivatives).to receive(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
        service.create_derivatives("sample.mp4")
        expect(Hydra::Derivatives::ActiveEncodeDerivatives).to have_received(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
      end

      context 'with custom options service class' do
        let(:options_service_class) { CustomOptionService }

        it 'calls the ActiveEncode runner with the original file, passing the encode class and the provided output options' do
          allow(Hydra::Derivatives::ActiveEncodeDerivatives).to receive(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
          service.create_derivatives("sample.mp4")
          expect(Hydra::Derivatives::ActiveEncodeDerivatives).to have_received(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
        end
      end
    end

    context 'with external streaming' do
      let(:service) { described_class.new(file_set, encode_class: encode_class, options_service_class: options_service_class, local_streaming: false) }
      let(:internal_options) { { file_set_id: file_set.id } }

      it 'calls the ActiveEncode runner with the original file, passing the encode class and the provided output options' do
        allow(Hydra::Derivatives::ActiveEncodeDerivatives).to receive(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
        service.create_derivatives("sample.mp4")
        expect(Hydra::Derivatives::ActiveEncodeDerivatives).to have_received(:create).with("sample.mp4", encode_class: encode_class, outputs: outputs)
      end
    end

    context 'image derivatives' do
      let(:outputs) do
        [{ label: :thumbnail, format: 'jpg', url: service.derivative_url('thumbnail') },
         { label: :poster, format: 'jpg', url: service.derivative_url('poster') }]
      end

      it 'calls Hydra-Derivatives to create thumbnail and poster' do
        allow(Hydra::Derivatives::VideoDerivatives).to receive(:create).with("sample.mp4", outputs: outputs)
        service.create_derivatives("sample.mp4")
        expect(Hydra::Derivatives::VideoDerivatives).to have_received(:create).with("sample.mp4", outputs: outputs)
      end
    end
  end

  # describe '#cleanup_derivatives' do
  # end

  describe '#derivative_url' do
    let(:file_set) { FileSet.create }
    let(:external_uri) { "http://test.file" }
    let(:derivative) do
      file_set.build_derivative.tap do |d|
        d.label = 'high'
        d.file_location_uri = external_uri
      end
    end

    before do
      derivative
    end

    it 'returns the external uri' do
      expect(service.derivative_url('high')).to eq external_uri
    end

    it 'returns nil if no matching derivative' do
      expect(service.derivative_url('missing')).to be_nil
    end

    context 'with thumbnail' do
      it 'returns the tmp filesystem path' do
        expect(service.derivative_url('thumbnail')).to match(/^file:.*-thumbnail.jpeg$/)
      end
    end

    context 'with poster' do
      it 'returns the tmp filesystem path' do
        # EWWW poster.poster!?!
        expect(service.derivative_url('poster')).to match(/^file:.*-poster.poster$/)
      end
    end
  end
end
