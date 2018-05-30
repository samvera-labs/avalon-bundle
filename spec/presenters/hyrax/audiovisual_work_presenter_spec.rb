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

# Generated via
#  `rails generate hyrax:work AudiovisualWork`
require 'rails_helper'
require 'support/shared_examples/concerns/displays_iiif_spec'

RSpec.describe Hyrax::AudiovisualWorkPresenter do
  it_behaves_like "DisplaysIIIF"

  let(:solr_document) { SolrDocument.new(id: '12345') }
  let(:request) { instance_double("Request", base_url: 'http://test.host') }
  let(:ability) { instance_double("Ability") }
  let(:presenter) { described_class.new(solr_document, ability, request) }
  let(:read_permission) { true }
  let(:id) { solr_document.id }

  let(:properties) do
    [:title,
     :date_issued,
     :date_created,
     :creator,
     :contributor,
     :publisher,
     :abstract,
     :physical_description,
     :language,
     :genre,
     :topical_subject,
     :temporal_subject,
     :geographic_subject,
     :permalink,
     :related_item,
     :bibliographic_id,
     :local,
     :oclc,
     :lccn,
     :issue_number,
     :matrix_number,
     :music_publisher,
     :video_recording_identifier,
     :table_of_contents,
     :note,
     :rights_statement,
     :license,
     :terms_of_use]
  end

  describe "delegation to solr_document" do
    it "delegate attribute accessors to solr_document" do
      properties.each do |property|
        expect(presenter).to delegate_method(property).to(:solr_document)
      end
    end

    it "#related_itme" do
      expect(solr_document).to receive(:related_item)
      presenter.send(:related_item)
    end

    it "#note" do
      expect(solr_document).to receive(:note)
      presenter.send(:note)
    end
  end

  describe "manifest_metadata" do
    it "respond to #manifest_metadata" do
      expect(presenter.respond_to?(:manifest_metadata)).to be true
    end

    it "to be an array and contains hashes with 'label' and 'value'" do
      expect(presenter.manifest_metadata).to be_kind_of Array
      expect(presenter.manifest_metadata.all? { |v| v.is_a? Hash }).to be true
      expect(presenter.manifest_metadata.all? { |v| v['label'].present? && v['value'] }).to be true
    end

    it "has all the labels translated" do
      expect(presenter.manifest_metadata.all? { |v| !v['label'].include?("translation missing: ") }).to be true
    end

    it "has all the labels translated" do
      expect(presenter.manifest.all? { |v| !v['label'].include?("translation missing: ") }).to be true
    end
  end
end
