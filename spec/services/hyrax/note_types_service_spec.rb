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

RSpec.describe Hyrax::NoteTypesService do
  describe "select_options" do
    subject { described_class.select_options }

    it "has a select list" do
      expect(subject.first).to eq ["General Note", "general"]
      expect(subject.size).to eq 9
    end
  end

  describe "label" do
    subject { described_class.label("awards") }

    it { is_expected.to eq 'Awards' }
  end
end
