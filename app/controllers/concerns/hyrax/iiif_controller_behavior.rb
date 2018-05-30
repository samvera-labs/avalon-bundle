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
