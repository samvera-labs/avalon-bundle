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

RSpec.describe GenericWorkHelper do
  let(:work_presenter) { instance_double("Hyrax::GenericWorkPresenter") }

  describe '#iiif_viewer_display' do
    let(:partial) { 'hyrax/base/iiif_viewers/universal_viewer' }

    before do
      allow(helper).to receive(:iiif_viewer_display_partial).with(work_presenter)
                                                            .and_return(partial)
    end

    it "renders a partial" do
      expect(helper).to receive(:render)
        .with(partial, presenter: work_presenter)
      helper.iiif_viewer_display(work_presenter)
    end

    it "takes options" do
      expect(helper).to receive(:render)
        .with(partial, presenter: work_presenter, transcript_id: '123')
      helper.iiif_viewer_display(work_presenter, transcript_id: '123')
    end
  end

  describe '#iiif_viewer_display_partial' do
    subject { helper.iiif_viewer_display_partial(work_presenter) }

    before do
      allow(helper).to receive(:iiif_viewer_for_work).with(work_presenter)
                                                     .and_return(:iiif_awesome)
    end

    it { is_expected.to eq 'hyrax/base/iiif_viewers/iiif_awesome' }
  end

  describe '#iiif_viewer_for_work' do
    subject { helper.iiif_viewer_for_work(work_presenter) }

    context 'when presenter does not respond to #iiif_viewer' do
      it { is_expected.to eq :universal_viewer }
    end

    context 'when presenter responds to #iiif_viewer' do
      before do
        allow(work_presenter).to receive(:iiif_viewer).and_return(:iiif_awesome)
      end

      it { is_expected.to eq :iiif_awesome }
    end
  end
end
