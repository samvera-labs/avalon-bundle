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

FactoryBot.define do
  factory :audiovisual_work, class: AudiovisualWork do
    title { ['Work title'] }
    date_issued { '1952' }
    date_created { ['1952'] }
    creator { ['Jane Doe'] }
    contributor { ['John Doe'] }
    publisher { ['Foo Bar Press'] }
    abstract { ['Lorem ipsum dolor sit amet, consectetur adipiscing elit...'] }
    physical_description { '33 1/3 R.P.M.' }
    language { ['English'] }
    genre { ['Thrash Metal'] }
    topical_subject { ['Audiovisual Software'] }
    temporal_subject { ['1960s'] }
    geographic_subject { ['Bloomington, Ind.'] }
    permalink { ['a1b2c3'] }
    related_item { ['http://example.com/another-resource'] }
    bibliographic_id { 'ABC1234' }
    local { ['ABC1234'] }
    oclc { ['ocn12345'] }
    lccn { ['12345678'] }
    issue_number { ['Issue#'] }
    matrix_number { ['Matrix#'] }
    music_publisher { ['M1234'] }
    video_recording_identifier { ['VID1234'] }
    table_of_contents { 'Table of Contents' }
    note { ['Statement of Responsibility: Jane Doe / Title'] }
    rights_statement { ['No Known Copyright'] }
    license { ['CC BY-SA-ND'] }
    terms_of_use { ['Terms of use for tests'] }
  end
end
