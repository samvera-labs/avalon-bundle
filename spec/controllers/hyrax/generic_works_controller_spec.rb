# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'

RSpec.describe Hyrax::GenericWorksController do
  routes { Rails.application.routes }
  let(:main_app) { Rails.application.routes.url_helpers }
  let(:hyrax) { Hyrax::Engine.routes.url_helpers }

  describe '#manifest' do
    let(:solr_document) { SolrDocument.new }
    let(:ability) { nil }
    let(:presenter) { Hyrax::GenericWorkPresenter.new(solr_document, ability, request) }
    let(:mime2) { Hyrax::GenericWorksController::IIIF_DEFAULT_MANIFEST_MIME.gsub("/#{Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION}/", "/2/") }
    let(:mime3) { Hyrax::GenericWorksController::IIIF_DEFAULT_MANIFEST_MIME.gsub("/#{Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION}/", "/3/") }
    let(:manifest_factory2) { instance_double("IIIFManifest::ManifestBuilder", to_h: { test: 'manifest2' }) }
    let(:manifest_factory3) { instance_double("IIIFManifest::V3::ManifestBuilder", to_h: { test: 'manifest3' }) }

    before do
      allow(controller).to receive(:presenter).and_return(presenter)
      allow(IIIFManifest::ManifestFactory).to receive(:new)
        .with(Hyrax::WorkShowPresenter)
        .and_return(manifest_factory2)
      allow(IIIFManifest::V3::ManifestFactory).to receive(:new)
         .with(Hyrax::WorkShowPresenter)
         .and_return(manifest_factory3)
      request.headers['Accept'] = mime
    end

    context 'for request accepting IIIF V2' do
      let(:mime) { mime2 }

      it 'returns IIIF V2 manifest' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq mime
        expect(response.body).to eq "{\"test\":\"manifest2\"}"
      end
      # end
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
        expect(response.headers['Content-Type']).to eq Hyrax::GenericWorksController::IIIF_DEFAULT_MANIFEST_MIME
        if (Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION == 2)
          expect(response.body).to eq "{\"test\":\"manifest2\"}"
        elsif (Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION == 3)
          expect(response.body).to eq "{\"test\":\"manifest3\"}"
        end
      end
    end

    context 'for request accepting both IIIF V2 and V3' do
      let(:mime) { "#{mime2},#{ mime3}" }

      it 'returns manifest with the highest accepted IIIF version' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq mime3
        expect(response.body).to eq "{\"test\":\"manifest3\"}"
      end
    end

  end
end
