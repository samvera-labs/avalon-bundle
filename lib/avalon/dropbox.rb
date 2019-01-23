# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

require 'digest/md5'

module Avalon
  class Dropbox
    MANIFEST_EXTENSIONS = ['csv','xls','xlsx','ods']

    attr_reader :base_directory, :admin_set

    def initialize(root, admin_set)
      @base_directory = root
      @admin_set = admin_set
    end

    # Returns all unprocessed manifests within this dropbox
    def manifests
      # TODO: handle s3 case, and use URI for source_location (need to change across batch ingest gem as well)
      Dir[File.join(base_directory, "**/*.{#{MANIFEST_EXTENSIONS.join(',')}}")]
    end
  end
end
