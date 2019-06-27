# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "active_encode_encode_records/index", type: :view do
  before do
    assign(:active_encode_encode_records, [
             ActiveEncodeEncodeRecord.create!(
               global_id: "Global",
               state: "State",
               adapter: "Adapter",
               title: "Title",
               raw_object: "MyText"
             ),
             ActiveEncodeEncodeRecord.create!(
               global_id: "Global",
               state: "State",
               adapter: "Adapter",
               title: "Title",
               raw_object: "MyText"
             )
           ])
  end

  it "renders a list of active_encode_encode_records" do
    render
    assert_select "tr>td", text: "Global".to_s, count: 2
    assert_select "tr>td", text: "State".to_s, count: 2
    assert_select "tr>td", text: "Adapter".to_s, count: 2
    assert_select "tr>td", text: "Title".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
