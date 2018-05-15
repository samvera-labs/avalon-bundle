require 'rails_helper'

RSpec.shared_examples "DisplaysIIIF" do
  let(:solr_document) { SolrDocument.new }
  let(:request) { double }
  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_document, ability, request) }

  describe '#iiif_viewer?' do
    subject { presenter.iiif_viewer? }

    let(:id_present) { true }
    let(:representative_presenter) { instance_double('Hyrax::FileSetPresenter', present?: true) }
    let(:image_boolean) { false }
    let(:audio_boolean) { false }
    let(:video_boolean) { false }
    let(:iiif_image_server) { false }

    before do
      allow(presenter).to receive(:representative_id).and_return(id_present)
      allow(presenter).to receive(:representative_presenter).and_return(representative_presenter)
      allow(representative_presenter).to receive(:image?).and_return(image_boolean)
      allow(representative_presenter).to receive(:audio?).and_return(audio_boolean)
      allow(representative_presenter).to receive(:video?).and_return(video_boolean)
      allow(Hyrax.config).to receive(:iiif_image_server?).and_return(iiif_image_server)
    end

    context 'with no representative_id' do
      let(:id_present) { false }

      it { is_expected.to be false }
    end

    context 'with no representative_presenter' do
      let(:representative_presenter) { instance_double('Hyrax::FileSetPresenter', present?: false) }

      it { is_expected.to be false }
    end

    context 'with non-image representative_presenter' do
      let(:image_boolean) { true }

      it { is_expected.to be false }
    end

    context 'with IIIF image server turned off' do
      let(:image_boolean) { true }
      let(:iiif_image_server) { false }

      it { is_expected.to be false }
    end

    context 'with representative image and IIIF turned on' do
      let(:image_boolean) { true }
      let(:iiif_image_server) { true }

      it { is_expected.to be true }
    end

    context 'with representative audio' do
      let(:audio_boolean) { true }

      it { is_expected.to be true }
    end

    context 'with representative video' do
      let(:video_boolean) { true }

      it { is_expected.to be true }
    end
  end

  describe '#iiif_viewer' do
    subject { presenter.iiif_viewer }

    let(:representative_presenter) { instance_double('Hyrax::FileSetPresenter', present?: true) }
    let(:image_boolean) { false }
    let(:audio_boolean) { false }
    let(:video_boolean) { false }

    before do
      allow(presenter).to receive(:representative_presenter).and_return(representative_presenter)
      allow(representative_presenter).to receive(:image?).and_return(image_boolean)
      allow(representative_presenter).to receive(:audio?).and_return(audio_boolean)
      allow(representative_presenter).to receive(:video?).and_return(video_boolean)
    end

    context 'with representative image' do
      let(:image_boolean) { true }

      it { is_expected.to be :universal_viewer }
    end

    context 'with representative audio' do
      let(:audio_boolean) { true }

      it { is_expected.to be :avalon }
    end

    context 'with representative video' do
      let(:video_boolean) { true }

      it { is_expected.to be :avalon }
    end

    context 'with no representative_presenter' do
      let(:representative_presenter) { instance_double('Hyrax::FileSetPresenter', present?: false) }

      it { is_expected.to be nil }
    end
  end
end
