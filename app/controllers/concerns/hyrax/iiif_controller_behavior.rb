module Hyrax
  module IIIFControllerBehavior
    extend ActiveSupport::Concern

    IIIF_PRESENTATION_2_MIME = "application/json;profile=http://iiif.io/api/presentation/2/context.json".freeze
    IIIF_PRESENTATION_3_MIME = "application/json;profile=http://iiif.io/api/presentation/3/context.json".freeze

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