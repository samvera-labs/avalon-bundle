require 'iiif_manifest'

module Hyrax
  # This gets mixed into FileSetPresenter in order to create
  # a canvas on a IIIF manifest
  module DisplaysContent
    extend ActiveSupport::Concern

    # Creates a display content only where FileSet is an image or video.
    #
    # @return [IIIFManifest::V3::DisplayContent] the display content required by the manifest builder.
    def display_content
      return nil unless ::FileSet.exists?(id) && content_supported? && current_ability.can?(:read, id)
      # @todo this is slow, find a better way (perhaps index iiif url):
      # original_file = ::FileSet.find(id).original_file
      # file_set = ::FileSet.find(id)
      file_set = solr_document

      if solr_document.image?
        image_content(file_set)
      elsif solr_document.video?
        video_content(file_set)
      elsif solr_document.audio?
        audio_content(file_set)
      else
        nil
      end
    end

    private

    def content_supported?
      solr_document.video? || solr_document.audio? #|| solr_document.image?
    end

    def image_content(original_file)
      url = Hyrax.config.iiif_image_url_builder.call(
        original_file.id,
        request.base_url,
        Hyrax.config.iiif_image_size_default
      )
      # @see https://github.com/samvera-labs/iiif_manifest
      IIIFManifest::V3::DisplayContent.new(url,
                                     width: 640,
                                     height: 480,
                                     type: 'Image',
                                     iiif_endpoint: iiif_endpoint(original_file.id))
    end

    def video_content(original_file)
      # @see https://github.com/samvera-labs/iiif_manifest
      [IIIFManifest::V3::DisplayContent.new(download_path(original_file, 'mp4'),
                                       width: original_file.width.try(:first),
                                       height: original_file.height.try(:first),
                                       duration: original_file.duration.try(:first),
                                       type: 'Video'),
       IIIFManifest::V3::DisplayContent.new(download_path(original_file, 'webm'),
                                        width: original_file.width.try(:first),
                                        height: original_file.height.try(:first),
                                        duration: original_file.duration.try(:first),
                                        type: 'Video')]
    end

    def audio_content(original_file)
      [IIIFManifest::V3::DisplayContent.new(download_path(original_file, 'ogg'),
                                       duration: original_file.duration.try(:first),
                                       type: 'Sound'),
       IIIFManifest::V3::DisplayContent.new(download_path(original_file, 'mp3'),
                                        duration: original_file.duration.try(:first),
                                        type: 'Sound')]
    end

    def download_path(file_set, extension)
      Hyrax::Engine.routes.url_helpers.download_url(file_set, file: extension, host: request.base_url)
    end
  end
end
