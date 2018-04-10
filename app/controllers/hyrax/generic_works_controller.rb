# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  # Generated controller for GenericWork
  class GenericWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::GenericWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::GenericWorkPresenter

    private

    def manifest_builder
      # TODO Switch to all V3 Manifests in the future or make based upon request headers
      if presenter.representative_presenter.image?
        ::IIIFManifest::ManifestFactory.new(presenter)
      else
        ::IIIFManifest::V3::ManifestFactory.new(presenter)
      end
    end
  end
end
