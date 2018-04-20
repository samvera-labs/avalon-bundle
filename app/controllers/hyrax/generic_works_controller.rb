# Generated via
#  `rails generate hyrax:work GenericWork`
module Hyrax

  # Generated controller for GenericWork
  class GenericWorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks

    IIIF_DEFAULT_VERSION = 2
    IIIF_DEFAULT_MANIFEST_MIME = "application/json;profile=http://iiif.io/api/presentation/#{IIIF_DEFAULT_VERSION}/context.json"

    self.curation_concern_type = ::GenericWork

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::GenericWorkPresenter

    # @return the highest IIIF version (as an integer) specified in the Accept request header, or the default version if none specified
    def iiifVersion
      version = IIIF_DEFAULT_VERSION
      accept = request.headers['Accept']
      # check for multiple profiles for highest IIIF version. Note: only digits are allowed in the version number
      regexp = Regexp.new(Regexp.escape(IIIF_DEFAULT_MANIFEST_MIME[/profile.*$/]).gsub("/#{IIIF_DEFAULT_VERSION}/", "/(\\d+)/"))
      accept.scan(regexp).each do |matched|
        v = matched[0].to_i
        version = v > version ? v : version
      end
      return version
    end

    # @return true if the request is for IIIF version 3; false otherwise
    def iiifVersion3?
      iiifVersion == 3
    end

    def manifest
      addIiifHeader
      super
    end

    private

    # Adds Content-Type response header based on request's Accept version
    def addIiifHeader
      headers['Content-Type'] = IIIF_DEFAULT_MANIFEST_MIME.gsub("/#{IIIF_DEFAULT_VERSION}/", "/#{iiifVersion}/")
    end

    def manifest_builder
      if iiifVersion3?
        ::IIIFManifest::V3::ManifestFactory.new(presenter)
      else
        ::IIIFManifest::ManifestFactory.new(presenter)
      end
  end
end
