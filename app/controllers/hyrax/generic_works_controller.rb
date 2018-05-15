# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  # Generated controller for GenericWork
  class GenericWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks

    IIIF_PRESENTATION_2_MIME = "application/json;profile=http://iiif.io/api/presentation/2/context.json".freeze
    IIIF_PRESENTATION_3_MIME = "application/json;profile=http://iiif.io/api/presentation/3/context.json".freeze

    self.curation_concern_type = ::GenericWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::GenericWorkPresenter

    def manifest
      add_iiif_header
      super
    end

    private

      # @return true if the request is for IIIF version 3; false otherwise
      def iiif_version_3?
        presenter.iiif_version == 3
      end

      def iiif_mime
        iiif_version_3? ? IIIF_PRESENTATION_3_MIME : IIIF_PRESENTATION_2_MIME
      end

      # Adds Content-Type response header based on request's Accept version
      def add_iiif_header
        headers['Content-Type'] = iiif_mime
      end

      def manifest_builder
        if iiif_version_3?
          ::IIIFManifest::V3::ManifestFactory.new(presenter)
        else
          ::IIIFManifest::ManifestFactory.new(presenter)
        end
      end
  end
end
