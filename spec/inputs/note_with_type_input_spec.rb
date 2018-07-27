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
require 'capybara/rspec'

RSpec.describe 'NoteWithTypeInput', type: :input do
  let(:work) { build(:audiovisual_work) }
  let(:builder) { SimpleForm::FormBuilder.new(:audiovisual_work, work, ActionView::Base.new, {}) }
  let(:input) { NoteWithTypeInput.new(builder, :note, nil, :note_with_type, {}) }

  describe '#build_field' do
    subject { input.send(:build_field, value, 0) }
    let(:value) { ["statement of responsibility", "Jane Doe / Title"] }

    it 'renders formated note' do
      # expect(subject).to have_selector('audiovisual_work[note_type][]',
      #   class: 'audiovisual_work_note form-control multi-text-field multi_value',
      #   # aria-labelledby: 'audiovisual_work_note_label',
      #   with_options: ['general', 'awards'],
      #   selected: 'statement of responsibility'
      # )
      # expect(subject).to have_field('audiovisual_work[note_body][]', type: 'textarea', with: 'Jane Doe / Title')
    end
  end
end
