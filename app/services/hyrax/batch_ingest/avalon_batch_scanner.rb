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

# frozen_string_literal: true
module Hyrax
  module BatchIngest
    class AvalonBatchScanner < Hyrax::BatchIngest::BatchScanner
      # attr_reader :admin_set

      # def initialize(admin_set)
      #   @admin_set = admin_set
      # end

      # # Scans dropboxes of all admin sets for new batch manifests, creates batches and run them.
      # def scan
      #   manifests = admin_set.dropbox.manifests
      #   logger.info "<< Found #{manifests.count} new manifests for admin_set #{@admin_set.title.first} >>" if manifests.count > 0
      #   manifests.each do |manifest|
      #     logger.info "<< Processing manifest #{manifest.absolute_path} for admin set #{admin_set.id} >>"
      #     # submitter_email will be populated later by batch reader
      #     Hyrax::BatchIngest::BatchRunner.new(ingest_type: 'Avalon Ingest Type', source_location: manifest.absolute_path, admin_set_id: admin_set.id).run
      #   end
      # end

      protected

      # Scans all sub-folders within this admin set's dropbox and returns all unprocessed manifests.
      def unprocessed_manifests
        admin_set.dropbox.manifests
      end

      # # Returns the source location of the specified manifest.
      # def manifest_location(manifest)
      #   admin_set.dropbox.manifest_location(manifest)
      # end
    end
  end
end