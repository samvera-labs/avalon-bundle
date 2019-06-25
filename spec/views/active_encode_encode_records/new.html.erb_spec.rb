require 'rails_helper'

RSpec.describe "active_encode_encode_records/new", type: :view do
  before(:each) do
    assign(:active_encode_encode_record, ActiveEncodeEncodeRecord.new(
      :global_id => "MyString",
      :state => "MyString",
      :adapter => "MyString",
      :title => "MyString",
      :raw_object => "MyText"
    ))
  end

  it "renders new active_encode_encode_record form" do
    render

    assert_select "form[action=?][method=?]", active_encode_encode_records_path, "post" do

      assert_select "input[name=?]", "active_encode_encode_record[global_id]"

      assert_select "input[name=?]", "active_encode_encode_record[state]"

      assert_select "input[name=?]", "active_encode_encode_record[adapter]"

      assert_select "input[name=?]", "active_encode_encode_record[title]"

      assert_select "textarea[name=?]", "active_encode_encode_record[raw_object]"
    end
  end
end
