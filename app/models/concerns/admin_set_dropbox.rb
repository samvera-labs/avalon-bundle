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

module AdminSetDropbox
  extend ActiveSupport::Concern

  included do
    # TODO: issue #258 change URI to avalon-bundle?
    property :dropbox_directory_name, predicate: ::RDF::URI.new('http://avalonmediasystem.org/rdf/vocab/collection#dropbox_directory_name'), multiple: false do |index|
      index.as :symbol
    end
  end

  def dropbox
    Avalon::Dropbox.new(dropbox_absolute_path, self)
  end

  def dropbox_absolute_path(name = nil)
    File.join(Settings.dropbox.path, name || dropbox_directory_name)
  end
end
