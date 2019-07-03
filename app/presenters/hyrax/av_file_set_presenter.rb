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
  class AVFileSetPresenter < Hyrax::IiifAv::IiifFileSetPresenter
    include Hyrax::IiifAv::DisplaysContent

    attr_accessor :media_fragment

    def range
      structure_ng_xml.root.blank? ? simple_iiif_range : structure_to_iiif_range
    end

    def encode_record
      return nil unless solr_document["encode_global_id_ssim"]
      encode_record = ::ActiveEncode::EncodeRecord.where(global_id: solr_document["encode_global_id_ssim"]).first
      encode_record ? ActiveEncodeEncodePresenter.new(encode_record) : nil
    end

    private

      def simple_iiif_range
        # TODO: embed_title?
        Hyrax::IiifAv::ManifestRange.new(
          label: { '@none'.to_sym => [title.first] },
          items: [
            clone.tap { |s| s.media_fragment = 't=0,' }
          ]
        )
      end

      def structure_to_iiif_range
        div_to_iiif_range(structure_ng_xml.root)
      end

      def div_to_iiif_range(div_node)
        items = div_node.children.select(&:element?).collect do |node|
          if node.name == "Div"
            div_to_iiif_range(node)
          elsif node.name == "Span"
            span_to_iiif_range(node)
          end
        end

        # if a non-leaf node has no valid "Div" or "Span" children, then it would become empty range node containing no canvas
        # raise an exception here as this error shall have been caught and handled by the parser and shall never happen here
        raise Nokogiri::XML::SyntaxError, "Empty root or Div node: #{div_node[:label]}" if items.empty?

        Hyrax::IiifAv::ManifestRange.new(
          label: { '@none'.to_sym => [div_node[:label]] },
          items: items
        )
      end

      def span_to_iiif_range(span_node)
        Hyrax::IiifAv::ManifestRange.new(
          label: { '@none'.to_sym => [span_node[:label]] },
          items: [
            clone.tap do |s|
              s.media_fragment = "t=#{parse_hour_min_sec(span_node[:begin])},#{parse_hour_min_sec(span_node[:end])}"
            end
          ]
        )
      end

      FLOAT_PATTERN = Regexp.new(/^\d+([.]\d*)?$/).freeze

      def parse_hour_min_sec(s)
        return nil if s.nil?
        smh = s.split(':').reverse
        (0..2).each do |i|
          # Use Regexp.match? when we drop ruby 2.3 support
          smh[i] = smh[i] =~ FLOAT_PATTERN ? Float(smh[i]) : 0
        end
        smh[0] + (60 * smh[1]) + (3600 * smh[2])
      end

      # Note that the method returns empty Nokogiri Document instead of nil when structure_tesim doesn't exist or is empty.
      def structure_ng_xml
        # TODO: The XML parser should handle invalid XML files, for ex, if a non-leaf node has no valid "Div" or "Span" children,
        # in which case SyntaxError shall be prompted to the user during file upload.
        # This can be done by defining some XML schema to require that at least one Div/Span child node exists
        # under root or each Div node, otherwise Nokogiri::XML parser will report error, and raise exception here.
        @structure_ng_xml ||= (s = solr_document['structure_tesim']).nil? ? Nokogiri::XML(nil) : Nokogiri::XML(s.first)
      end
  end
end
