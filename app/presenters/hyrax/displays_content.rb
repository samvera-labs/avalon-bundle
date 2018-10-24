# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
# University. Additional copyright may be held by others, as reflected in
# the commit history.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

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

      return image_content if solr_document.image?
      return video_content if solr_document.video?
      return audio_content if solr_document.audio?
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

        # Look at the request and target prezi 2 or 3 for images
        parent.iiif_version == 3 ? image_content_v3(url) : image_content_v2(url)
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
        if solr_document['derivatives_metadata_ssi'].present?
          derivatives_metadata = JSON.parse(solr_document['derivatives_metadata_ssi'])
          external_files = derivatives_metadata.select { |f| f['external_file_uri'].present? }
          return external_files.map { |f| video_display_content(f['external_file_uri'], f['label']) } unless external_files.empty?
        end
        [video_display_content(download_path('mp4'), 'mp4'), video_display_content(download_path('webm'), 'webm')]
      end

      def video_display_content(url, label = '')
        IIIFManifest::V3::DisplayContent.new(url,
                                             label: label,
                                             width: Array(solr_document.width).first.try(:to_i),
                                             height: Array(solr_document.height).first.try(:to_i),
                                             duration: Array(solr_document.duration).first.try(:to_i) / 1000.0,
                                             type: 'Video')
      end

      def audio_content
        if solr_document['derivatives_metadata_ssi'].present?
          derivatives_metadata = JSON.parse(solr_document['derivatives_metadata_ssi'])
          external_files = derivatives_metadata.select { |f| f['external_file_uri'].present? }
          return external_files.map { |f| audio_display_content(f['external_file_uri'], f['label']) } unless external_files.empty?
        end
        [audio_display_content(download_path('ogg'), 'ogg'), audio_display_content(download_path('mp3'), 'mp3')]
      end

      def audio_display_content(url, label = '')
        IIIFManifest::V3::DisplayContent.new(url,
                                             label: label,
                                             duration: Array(solr_document.duration).first.try(:to_i) / 1000.0,
                                             type: 'Sound')
      end

      def download_path(extension)
        Hyrax::Engine.routes.url_helpers.download_url(solr_document, file: extension, host: request.base_url)
      end
  end
end
