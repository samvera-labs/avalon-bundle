# Generated via
#  `rails generate hyrax:work GenericWork`
require 'rails_helper'

RSpec.describe Hyrax::GenericWorksController, clean_repo: true do
  routes { Rails.application.routes }
  let(:main_app) { Rails.application.routes.url_helpers }
  let(:hyrax) { Hyrax::Engine.routes.url_helpers }
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#manifest' do
    let(:work) { create(:work_with_one_file, user: user) }
    let(:file_set) { work.ordered_members.to_a.first }
    let(:manifest_factory2) { double(to_h: { test: 'manifest2' }) }
    let(:manifest_factory3) { double(to_h: { test: 'manifest3' }) }

    before do
      Hydra::Works::AddFileToFileSet.call(file_set,
                                          File.open(fixture_path + file),
                                          :original_file)
      allow(IIIFManifest::ManifestFactory).to receive(:new)
                                                  .with(Hyrax::WorkShowPresenter)
                                                  .and_return(manifest_factory2)
      allow(IIIFManifest::V3::ManifestFactory).to receive(:new)
                                                      .with(Hyrax::WorkShowPresenter)
                                                      .and_return(manifest_factory3)
      @request.headers['Accept'] = mime
    end

    context 'with IIIF V2' do
      let(:mime) { Hyrax::GenericWorksController::IIIF_DEFAULT_MANIFEST_MIME.gsub("/#{Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION}/", "/2/")}

      context 'for image' do
        let(:file) { '/image.png' }
        it do
          get :manifest, params: { id: work, format: :json }
          expect(response.headers['Content-Type']).to eq mime
          expect(response.body).to eq "{\"test\":\"manifest2\"}"
        end
      end

      context 'for audio' do
        let(:file) { '/piano_note.wav' }
        it do
          get :manifest, params: { id: work, format: :json }
          expect(response.headers['Content-Type']).to eq mime
          expect(response.body).to eq "{\"test\":\"manifest2\"}"
        end
      end

      context 'for video' do
        let(:file) { '/countdown.avi' }
        it do
          get :manifest, params: { id: work, format: :json }
          expect(response.headers['Content-Type']).to eq mime
          expect(response.body).to eq "{\"test\":\"manifest2\"}"
        end
      end
    end

    context 'with IIIF V3' do
      let(:mime) { Hyrax::GenericWorksController::IIIF_DEFAULT_MANIFEST_MIME.gsub("/#{Hyrax::GenericWorksController::IIIF_DEFAULT_VERSION}/", "/3/")}

      context 'for image' do
        let(:file) { '/image.jpg' }
        it do
          get :manifest, params: { id: work, format: :json }
          expect(response.headers['Content-Type']).to eq mime
          expect(response.body).to eq "{\"test\":\"manifest3\"}"
        end
      end

      context 'for audio' do
        let(:file) { '/hyrax_test5.mp3' }
        it do
          get :manifest, params: { id: work, format: :json }
          expect(response.headers['Content-Type']).to eq mime
          expect(response.body).to eq "{\"test\":\"manifest3\"}"
        end
      end

      context 'for video' do
        let(:file) { '/sample_mpeg4.mp4' }
        it do
          get :manifest, params: { id: work, format: :json }
          expect(response.headers['Content-Type']).to eq mime
          expect(response.body).to eq "{\"test\":\"manifest3\"}"
        end
      end
    end

  end
end
