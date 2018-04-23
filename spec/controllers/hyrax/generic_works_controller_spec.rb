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

    context 'with IIIF V2 request' do
      let(:mime) { Hyrax::GenericWorksController::IIIF_DEFAULT_MANIFEST_MIME.gsub("/#{Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION}/", "/2/") }

      it 'returns IIIF V2 manifest' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq mime
        expect(response.body).to eq "{\"test\":\"manifest2\"}"
      end
      # end
    end

    context 'with IIIF V3 request' do
      let(:mime) { Hyrax::GenericWorksController::IIIF_DEFAULT_MANIFEST_MIME.gsub("/#{Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION}/", "/3/") }

      it 'returns IIIF V3 manifest' do
        get :manifest, params: { id: 'testwork', format: :json }
        expect(response.headers['Content-Type']).to eq mime
        expect(response.body).to eq "{\"test\":\"manifest3\"}"
      end
    end
  end
end
