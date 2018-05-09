FactoryBot.define do
  factory :audiovisual_work, class: AudiovisualWork do
    date_created { ['1952'] }
    license { ['CC BY-SA-ND'] }
    related_item { ['http://example.com/another-resource'] }
    identifier { ['a1b2c3'] }
    creator { ['Jane Doe'] }
    contributor { ['John Doe'] }
    publisher { ['Foo Bar Press'] }
    language { ['English'] }
    date_issued { '1952' }
    abstract { ['Lorem ipsum dolor sit amet, consectetur adipiscing elit...'] }
    genre { ['Thrash Metal'] }
    topical_subject { ['Audiovisual Software'] }
    geographic_subject { ['Bloomington, Ind.'] }
    temporal_subject { ['1960s'] }
    physical_description { '33 1/3 R.P.M.' }
    table_of_contents { 'Table of Contents' }
    note { ['Statement of Responsibility: Jane Doe / Title'] }
    bibliographic_id { 'ABC1234' }
    local { ['ABC1234'] }
    lccn { ['12345678'] }
    issue_number { ['Issue#'] }
    matrix_number { ['Matrix#'] }
    music_publisher { ['M1234'] }
    video_recording_identifier { ['VID1234'] }
    oclc { ['ocn12345'] }
  end
end
