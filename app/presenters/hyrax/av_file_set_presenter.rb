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

require 'avalon/manifest_range'

module Hyrax
  class AVFileSetPresenter < Hyrax::FileSetPresenter
    include DisplaysContent

    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::AVFileSetPresenter

    attr_accessor :media_fragment

    def range
      structure_ng_xml.empty? ? simple_iiif_range : structure_to_iiif_range
    end

    private

    def simple_iiif_range
      # TODO embed_title?
      Avalon::ManifestRange.new(
          label: {'@none'.to_sym => [title.first]},
          items: [
            self.clone.tap { |s| s.media_fragment = 't=0,'}
          ]
      )
    end

    def structure_to_iiif_range
      div_to_iiif_range(structure_ng_xml.root)
    end

    def div_to_iiif_range(div_node)
      # TODO handle the case when items is empty, or does not contain any Div/Span node
      items = div_node.children.select {|child| child.element?}.collect do |node|
        if node.name == "Div"
          div_to_iiif_range(node)
        elsif node.name == "Span"
          span_to_iiif_range(node)
        end
      end
      Avalon::ManifestRange.new(
          label: {'@none'.to_sym => [div_node[:label]]},
          items: items
      )
    end

    def span_to_iiif_range(span_node)
      Avalon::ManifestRange.new(
          label: {'@none'.to_sym => [span_node[:label]]},
          items: [
              self.clone.tap do |s|
                s.media_fragment = "t=#{parse_hour_min_sec(span_node[:begin])},#{parse_hour_min_sec(span_node[:end])}"
              end
          ]
      )
    end

    def parse_hour_min_sec s
      return nil if s.nil?
      smh = s.split(':').reverse
      (Float(smh[0]) rescue 0) + 60*(Float(smh[1]) rescue 0) + 3600*(Float(smh[2]) rescue 0)
    end

    def structure_ng_xml
      @structure_ng_xml ||= Nokogiri::XML(solr_document['structure_tesim'])
    end

  end
  
end
