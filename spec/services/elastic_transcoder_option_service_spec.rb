# Copyright 2011-2019, The Trustees of Indiana University and Northwestern
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
require 'rails_helper'
require 'aws-sdk'

RSpec.describe ElasticTranscoderOptionService do
  describe "call" do
    before do
      preset = instance_double("Aws::ElasticTranscoder::Types::Preset", id: "my_preset_id")
      allow(described_class).to receive(:find_or_create_preset).and_return(preset)
    end

    context "audio" do
      subject { described_class.call(file_set) }

      let(:file_set) { instance_double("FileSet", audio?: true, label: "my_file.mp4") }

      it "returns correct options for audio ingest" do
        expect(subject).to eq [{ pipeline_id: "my_pipeline_id",
                                 masterfile_bucket: "my_bucket_id",
                                 outputs: [{ key: "quality-medium/hls/my_file.mp4",
                                             preset_id: "my_preset_id",
                                             segment_duration: '2' },
                                           { key: "quality-high/hls/my_file.mp4",
                                             preset_id: "my_preset_id",
                                             segment_duration: '2' }] }]
      end
    end

    context "video" do
      subject { described_class.call(file_set) }

      let(:file_set) { instance_double("FileSet", audio?: false, video?: true, label: "my_file.mp4") }

      it "returns correct options for video ingest" do
        expect(subject).to eq [{ pipeline_id: "my_pipeline_id",
                                 masterfile_bucket: "my_bucket_id",
                                 outputs: [{ key: "quality-low/hls/my_file.mp4",
                                             preset_id: "my_preset_id",
                                             segment_duration: '2' },
                                           { key: "quality-medium/hls/my_file.mp4",
                                             preset_id: "my_preset_id",
                                             segment_duration: '2' },
                                           { key: "quality-high/hls/my_file.mp4",
                                             preset_id: "my_preset_id",
                                             segment_duration: '2' }] }]
      end
    end
  end

  describe "find_or_create_preset" do
    let(:client) { Aws::ElasticTranscoder::Client.new(stub_responses: true) }
    let(:preset) do
      instance_double("Aws::ElasticTranscoder::Types::Preset", id: "preset_id", name: "avalon-audio-medium-hls")
    end

    context "preset doesn't exist" do
      before do
        client.stub_responses(:create_preset, create_preset_response)
        client.stub_responses(:list_presets, [])
        allow(described_class).to receive(:client).and_return(client)
      end

      subject { described_class.find_or_create_preset('ts', :audio, :medium) }

      let(:create_preset_response) do
        instance_double("Aws::ElasticTranscoder::Types::CreatePresetsResponse", preset: preset)
      end

      it "creates new preset" do
        expect(subject).to eq preset
      end
    end

    context "preset exists" do
      before do
        client.stub_responses(:list_presets, list_preset_response)
        allow(described_class).to receive(:client).and_return(client)
      end

      subject { described_class.find_or_create_preset('ts', :audio, :medium) }

      let(:list_preset_response) do
        instance_double("Aws::ElasticTranscoder::Types::ListPresetsResponse", presets: [preset], next_page_token: nil)
      end

      it "returns the preset" do
        expect(subject).to eq preset
      end
    end
  end
end
