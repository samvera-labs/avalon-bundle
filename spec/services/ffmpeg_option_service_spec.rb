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

require 'rails_helper'

RSpec.describe FfmpegOptionService do
  describe "call" do
    before do
      allow(described_class).to receive(:audio_encoder).and_return(instance_double("Hydra::Derivatives::AudioEncoder", audio_encoder: "an_audio_encoder"))
    end

    context "audio" do
      subject { described_class.call(file_set) }

      let(:file_set) { instance_double("FileSet", audio?: true) }

      it "returns correct options for audio ingest" do
        expect(subject).to eq [{ outputs: [{ label: 'high',
                                             extension: 'mp4',
                                             ffmpeg_opt: "-ac 2 -ab 192k -ar 44100 -acodec an_audio_encoder" },
                                           { label: 'medium',
                                             extension: 'mp4',
                                             ffmpeg_opt: "-ac 2 -ab 128k -ar 44100 -acodec an_audio_encoder" }] }]
      end
    end

    context "video" do
      subject { described_class.call(file_set) }

      let(:file_set) { instance_double("FileSet", audio?: false, video?: true) }

      it "returns correct options for video ingest" do
        expect(subject).to eq [{ outputs: [{ label: 'high',
                                             extension: 'mp4',
                                             ffmpeg_opt: "-s 1920x1080 -g 30 -b:v 800k -ac 2 -ab 192k -ar 44100 -vcodec libx264 -acodec an_audio_encoder" },
                                           { label: 'medium',
                                             extension: 'mp4',
                                             ffmpeg_opt: "-s 1280x720 -g 30 -b:v 500k -ac 2 -ab 128k -ar 44100 -vcodec libx264 -acodec an_audio_encoder" },
                                           { label: 'low',
                                             extension: 'mp4',
                                             ffmpeg_opt: "-s 720x360 -g 30 -b:v 300k -ac 2 -ab 96k -ar 44100 -vcodec libx264 -acodec an_audio_encoder" }] }]
      end
    end
  end
end
