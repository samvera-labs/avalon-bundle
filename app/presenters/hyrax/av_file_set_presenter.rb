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
  class AVFileSetPresenter < Hyrax::FileSetPresenter
    include DisplaysContent

    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::AVFileSetPresenter

    attr_accessor :media_fragment

    def range
      # TODO replace this example with the crosswalked structure
      ManifestRange.new(
        label: 'Parent Range',
        items:[
          self.clone.tap { |s| s.media_fragment = 't=0,50'},
          ManifestRange.new(
            label: 'Child Leaf',
            items: [
              self.clone.tap { |s| s.media_fragment = 't=50,100'}
            ]
          ),
          self.clone.tap { |s| s.media_fragment = 't=100,150'}
        ]
      )
    end
  end

  class ManifestRange
    attr_reader :label, :ranges, :file_set_presenters, :items
    def initialize(label:, ranges: [], file_set_presenters: [], items: [])
      @label = label
      @ranges = ranges
      @file_set_presenters = file_set_presenters
      @items = items
    end
  end
end
