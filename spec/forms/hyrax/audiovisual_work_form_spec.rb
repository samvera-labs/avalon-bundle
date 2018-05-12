# Generated via
#  `rails generate hyrax:work AudiovisualWork`
require 'rails_helper'

RSpec.describe Hyrax::AudiovisualWorkForm do
  let(:work) { AudiovisualWork.new }
  let(:form) { described_class.new(work, nil, nil) }

  let(:required_fields) { [:title, :date_issued] }

  let(:optional_fields) do
    [:date_created, :creator, :contributor, :publisher,
     :abstract, :physical_description, :language, :genre,
     :topical_subject, :temporal_subject, :geographic_subject, :permalink,
     :related_item, :bibliographic_id, :local, :oclc, :lccn, :issue_number,
     :matrix_number, :music_publisher, :video_recording_identifier,
     :table_of_contents, :note, :rights_statement, :license, :terms_of_use]
  end

  describe "#required_fields" do
    subject { form.required_fields }

    it { is_expected.to eq required_fields }
  end

  describe "#primary_terms" do
    subject { form.primary_terms }

    it { is_expected.to eq required_fields }
  end

  describe "#secondary_terms" do
    subject { form.secondary_terms }

    it { is_expected.to eq optional_fields }
  end
end
