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

RSpec.describe 'RelatedItemWithLabelInput', type: :input do
  let(:work) { build(:audiovisual_work) }
  let(:builder) { SimpleForm::FormBuilder.new(:audiovisual_work, work, ActionView::Base.new, {}) }
  let(:input) { RelatedItemWithLabelInput.new(builder, :related_item, nil, :related_item_with_label_input, {}) }

  describe '#build_field' do
    subject { input.send(:build_field, value, 0) }
    let(:value) { ["Another Resource", "http://example.com/another-resource"]  }

    it 'renders related_item input form' do
      expect(subject).to have_field('audiovisual_work[related_item_label][]', type: 'text', with: 'Another Resource')
      expect(subject).to have_field('audiovisual_work[related_item_url][]', type: 'text', with: 'http://example.com/another-resource')
    end
  end
end
