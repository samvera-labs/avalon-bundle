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
  module BatchIngest
    class AvalonBatchScanner
      attr_reader :admin_set

      def initialize(admin_set)
        @admin_set = admin_set
      end

      # Scans the dropbox for new batch packages and registers them
      #
      def scan
        # Scan the dropbox
        manifests = admin_set.dropbox.manifests
        logger.info "<< Found #{manifests.count} new manifests for admin_set #{@admin_set.title.first} >>" if manifests.count > 0
        manifests.each do |manifest|
          Hyrax::BatchIngest::BatchRunner.new(admin_set_id: admin_set.id, source_location: manifest.absolute_path, ingest_type: 'Avalon Ingest Type').run
        end
      end

    end
  end
end