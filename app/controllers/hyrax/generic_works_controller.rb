# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax
  # Generated controller for GenericWork
  class GenericWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks

    IIIF_DEFAULT_VERSION = 2
    IIIF_DEFAULT_MANIFEST_MIME = "application/json;profile=http://iiif.io/api/presentation/#{IIIF_DEFAULT_VERSION}/context.json".freeze

    self.curation_concern_type = ::GenericWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::GenericWorkPresenter

    def manifest
      add_iiif_header
      super
    end

    private

      # @return the highest IIIF version (as an integer) specified in the Accept request header, or the default version if none specified
      def iiif_version
        version = 0 # assume all valid versions will be at least greater than 0
        accept = request.headers['Accept']
        # check for multiple profiles for highest IIIF version. Note: only digits are allowed in the version number
        regexp = Regexp.new(Regexp.escape(IIIF_DEFAULT_MANIFEST_MIME[/profile.*$/]).gsub("/#{IIIF_DEFAULT_VERSION}/", "/(\\d+)/"))
        accept.scan(regexp).each do |matched|
          v = matched[0].to_i
          version = v > version ? v : version
        end
        version.zero? ? IIIF_DEFAULT_VERSION : version
      end

      # @return true if the request is for IIIF version 3; false otherwise
      def iiif_version_3?
        iiif_version == 3
      end

      # Adds Content-Type response header based on request's Accept version
      def add_iiif_header
        headers['Content-Type'] = IIIF_DEFAULT_MANIFEST_MIME.gsub("/#{IIIF_DEFAULT_VERSION}/", "/#{iiif_version}/")
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
