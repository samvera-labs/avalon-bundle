require 'iiif_manifest'

module Hyrax
  # This gets mixed into FileSetPresenter in order to create
  # a canvas on a IIIF manifest
  module DisplaysContent
    extend ActiveSupport::Concern

    # Creates a display content only where FileSet is an image, audio, or video.
    #
    # @return [IIIFManifest::V3::DisplayContent] the display content required by the manifest builder.
    def display_content
      return nil unless display_content_allowed?

      image_content if solr_document.image?
      video_content if solr_document.video?
      audio_content if solr_document.audio?
    end

    private

      def display_content_allowed?
        content_supported? && current_ability.can?(:read, id)
      end

      def content_supported?
        solr_document.video? || solr_document.audio? || solr_document.image?
      end

      def image_content
        url = Hyrax.config.iiif_image_url_builder.call(
          solr_document.id,
          request.base_url,
          Hyrax.config.iiif_image_size_default
        )

        # TODO: look at the request and target prezi 2 or 3 for images
        image_content_v2(url)
      end

      def image_content_v3(url)
        # @see https://github.com/samvera-labs/iiif_manifest
        IIIFManifest::V3::DisplayContent.new(url,
                                             width: 640,
                                             height: 480,
                                             type: 'Image',
                                             iiif_endpoint: iiif_endpoint(solr_document.id))
      end

      def image_content_v2(url)
        # @see https://github.com/samvera-labs/iiif_manifest
        IIIFManifest::DisplayImage.new(url,
                                       width: 640,
                                       height: 480,
                                       iiif_endpoint: iiif_endpoint(solr_document.id))
      end

      def video_content
        # @see https://github.com/samvera-labs/iiif_manifest
        [video_display_content("mp4"), video_display_content("webm")]
      end

      def video_display_content(type)
        IIIFManifest::V3::DisplayContent.new(download_path(type),
                                             width: Array(solr_document.width).first.try(:to_i),
                                             height: Array(solr_document.height).first.try(:to_i),
                                             duration: Array(solr_document.duration).first.try(:to_i),
                                             type: 'Video')
      end

      def audio_content
        [audio_display_content('ogg'), audio_display_content('mp3')]
      end

      def audio_display_content(type)
        IIIFManifest::V3::DisplayContent.new(download_path(type),
                                             duration: Array(solr_document.duration).first.try(:to_i),
                                             type: 'Sound')
      end

      def download_path(extension)
        Hyrax::Engine.routes.url_helpers.download_url(solr_document, file: extension, host: request.base_url)
      end
  end
end