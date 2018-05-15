require 'rails_helper'

RSpec.shared_examples "IIIFControllerBehavior" do
  routes { Rails.application.routes }
  let(:main_app) { Rails.application.routes.url_helpers }
  let(:hyrax) { Hyrax::Engine.routes.url_helpers }
  let(:presenter_class) { described_class.show_presenter }

  describe '#manifest' do
    let(:solr_document) { SolrDocument.new }
    let(:ability) { nil }
    let(:presenter) { presenter_class.new(solr_document, ability, request) }
    let(:mime2) { Hyrax::IIIFControllerBehavior::IIIF_PRESENTATION_2_MIME }
    let(:mime3) { Hyrax::IIIFControllerBehavior::IIIF_PRESENTATION_3_MIME }
    let(:manifest_factory2) { instance_double("IIIFManifest::ManifestBuilder", to_h: { test: 'manifest2' }) }
    let(:manifest_factory3) { instance_double("IIIFManifest::V3::ManifestBuilder", to_h: { test: 'manifest3' }) }

    before do
      allow(controller).to receive(:presenter).and_return(presenter)
      allow(IIIFManifest::ManifestFactory).to receive(:new).with(presenter).and_return(manifest_factory2)
      allow(IIIFManifest::V3::ManifestFactory).to receive(:new).with(presenter).and_return(manifest_factory3)
      request.headers['Accept'] = mime
    end

    context 'for request accepting IIIF V2' do
      let(:mime) { mime2 }

      it 'returns IIIF V2 manifest' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq mime
        expect(response.body).to eq "{\"test\":\"manifest2\"}"
      end
    end

    context 'for request accepting IIIF V3' do
      let(:mime) { mime3 }

      it 'returns IIIF V3 manifest' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq mime
        expect(response.body).to eq "{\"test\":\"manifest3\"}"
      end
    end

    context 'for request without IIIF profile' do
      let(:mime) { "application/json;" }

      it 'returns IIIF default version manifest' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq Hyrax::IIIFControllerBehavior::IIIF_PRESENTATION_2_MIME
        # the following code assumes Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION is 2;
        # if this constant changes, this code also needs to be changed accordingly
        expect(response.body).to eq "{\"test\":\"manifest2\"}"
      end
    end

    context 'for request accepting both IIIF V2 and V3' do
      let(:mime) { "#{mime2},#{mime3}" }

      it 'returns manifest with the highest accepted IIIF version' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq mime3
        expect(response.body).to eq "{\"test\":\"manifest3\"}"
      end
    end

    context 'for request without accept header' do
      let(:mime) { nil }

      it 'returns manifest with the highest accepted IIIF version' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq Hyrax::IIIFControllerBehavior::IIIF_PRESENTATION_2_MIME
        expect(response.body).to eq "{\"test\":\"manifest2\"}"
      end

      context 'for work with audio representative media' do
        let(:mime) { nil }
        let(:presenter) { presenter_class.new(solr_document, ability, request) }
        let(:rep_presenter) { instance_double("Hyrax::FileSetPresenter", audio?: true, video?: false) }

        before do
          allow(presenter).to receive(:representative_presenter).and_return(rep_presenter)
        end

        it 'returns manifest with the highest accepted IIIF version' do
          get :manifest, params: { id: 'testwork', format: :json }
          expect(response.headers['Content-Type']).to eq mime3
          expect(response.body).to eq "{\"test\":\"manifest3\"}"
        end
      end

      context 'for work with video representative media' do
        let(:mime) { nil }
        let(:presenter) { presenter_class.new(solr_document, ability, request) }
        let(:rep_presenter) { instance_double("Hyrax::FileSetPresenter", audio?: false, video?: true) }

        before do
          allow(presenter).to receive(:representative_presenter).and_return(rep_presenter)
        end

        it 'returns manifest with the highest accepted IIIF version' do
          get :manifest, params: { id: 'testwork', format: :json }
          expect(response.headers['Content-Type']).to eq mime3
          expect(response.body).to eq "{\"test\":\"manifest3\"}"
        end
      end

      context 'for work with non-av representative media' do
        let(:mime) { nil }
        let(:presenter) { presenter_class.new(solr_document, ability, request) }
        let(:rep_presenter) { instance_double("Hyrax::FileSetPresenter", audio?: false, video?: false) }

        before do
          allow(presenter).to receive(:representative_presenter).and_return(rep_presenter)
        end

        it 'returns manifest with the highest accepted IIIF version' do
          get :manifest, params: { id: 'testwork', format: :json }
          expect(response.headers['Content-Type']).to eq mime2
          expect(response.body).to eq "{\"test\":\"manifest2\"}"
        end
      end
    end

    context 'for request with default browser accept header' do
      let(:mime) { "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" }

      it 'returns manifest with the highest accepted IIIF version' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq Hyrax::IIIFControllerBehavior::IIIF_PRESENTATION_2_MIME
        expect(response.body).to eq "{\"test\":\"manifest2\"}"
      end

      context 'for work with audio representative media' do
        let(:mime) { nil }
        let(:presenter) { presenter_class.new(solr_document, ability, request) }
        let(:rep_presenter) { instance_double("Hyrax::FileSetPresenter", audio?: true, video?: false) }

        before do
          allow(presenter).to receive(:representative_presenter).and_return(rep_presenter)
        end

        it 'returns manifest with the highest accepted IIIF version' do
          get :manifest, params: { id: 'testwork', format: :json }
          expect(response.headers['Content-Type']).to eq mime3
          expect(response.body).to eq "{\"test\":\"manifest3\"}"
        end
      end

      context 'for work with video representative media' do
        let(:mime) { nil }
        let(:presenter) { presenter_class.new(solr_document, ability, request) }
        let(:rep_presenter) { instance_double("Hyrax::FileSetPresenter", audio?: false, video?: true) }

        before do
          allow(presenter).to receive(:representative_presenter).and_return(rep_presenter)
        end

        it 'returns manifest with the highest accepted IIIF version' do
          get :manifest, params: { id: 'testwork', format: :json }
          expect(response.headers['Content-Type']).to eq mime3
          expect(response.body).to eq "{\"test\":\"manifest3\"}"
        end
      end

      context 'for work with non-av representative media' do
        let(:mime) { nil }
        let(:presenter) { presenter_class.new(solr_document, ability, request) }
        let(:rep_presenter) { instance_double("Hyrax::FileSetPresenter", audio?: false, video?: false) }

        before do
          allow(presenter).to receive(:representative_presenter).and_return(rep_presenter)
        end

        it 'returns manifest with the highest accepted IIIF version' do
          get :manifest, params: { id: 'testwork', format: :json }
          expect(response.headers['Content-Type']).to eq mime2
          expect(response.body).to eq "{\"test\":\"manifest2\"}"
        end
      end
    end
  end
end
