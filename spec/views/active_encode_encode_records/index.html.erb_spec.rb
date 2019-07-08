# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "active_encode_encode_records/index", type: :view do
  it "renders a table with headings (contents not loading via ajax)" do
    render
    assert_select "tr>th", text: "Status".to_s, count: 1
    assert_select "tr>th", text: "ID".to_s, count: 1
    assert_select "tr>th", text: "Progress".to_s, count: 1
    assert_select "tr>th", text: "Filename".to_s, count: 1
    assert_select "tr>th", text: "Fileset".to_s, count: 1
    assert_select "tr>th", text: "Work".to_s, count: 1
  end
end
