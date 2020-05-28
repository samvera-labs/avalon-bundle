require 'rails_helper'
require 'hyrax/batch_ingest/spec/shared_specs'

describe Hyrax::BatchIngest::AudiovisualWorkItemIngester, clean_repo: true do
  let(:user) { create(:admin) }
  let(:submitter_email) { user.email }
  # let(:admin_set_id) { ::AdminSet.find_or_create_default_admin_set_id }
  let(:batch) { Hyrax::BatchIngest::Batch.new(submitter_email: submitter_email, admin_set_id: admin_set.id) }
  let(:source_data) do
    {
      "fields" => { "bibliographic_id_label" => ["Catalog Key"], "bibliographic_id" => ["3671440"],
                    "other_identifier_type" => ["OCLC"], "other_identifier" => ["39096003"],
                    "title" => ["lroom"], "creator" => ["I"], "contributor" => ["saidulla"],
                    "publisher" => ["lroompubs"], "date_issued" => ["1990"],
                    "topical_subject" => ["Social engineering"], "publish" => false, "hidden" => false },
      "files" => [{ "file" => "assets/lunchroom_manners.mp4", "label" => "lunchroom", "skip_transcoding" => true }]
    }
  end
  let(:batch_item) { batch.batch_items.build(source_data: source_data.to_json) }
  let(:ingester_class) { described_class }

  let(:admin_set) { create(:admin_set) }
  let(:permission_template) { create(:permission_template, source_id: admin_set.id) }
  let(:workflow) { create(:workflow, allows_access_grant: true, active: true, permission_template_id: permission_template.id) }

  before do
    create(:workflow_action, workflow_id: workflow.id)
  end

  it_behaves_like 'a Hyrax::BatchIngest::BatchItemIngester'

  describe '#attributes' do
    subject(:attributes) { ingester.attributes }

    let(:ingester) { described_class.new(batch_item) }
    let(:allowed_attributes) { AudiovisualWork.schema.map(&:name).map(&:to_s) + ['admin_set_id'] }

    its(['date_issued']) { is_expected.to eq '1990' }
    its(['title']) { is_expected.to eq ['lroom'] }
    its(['topical_subject']) { is_expected.to eq ['Social engineering'] }
    its(['creator']) { is_expected.to eq ['I'] }
    its(['contributor']) { is_expected.to eq ['saidulla'] }
    its(['publisher']) { is_expected.to eq ['lroompubs'] }
    its(['bibliographic_id']) { is_expected.to eq '3671440' }
    its(['admin_set_id']) { is_expected.to eq admin_set.id }
    # TODO: test for other identifier

    it 'has only allowed attributes' do
      attributes.each_key do |attr|
        expect(allowed_attributes.include?(attr)).to eq true
      end
    end
  end

  describe '#ingest' do
    let(:ingester) { described_class.new(batch_item) }
    let(:created_work) { ingester.ingest }

    xit 'ingests' do
      expect(created_work).to be_a AudiovisualWork
    end
  end
end
