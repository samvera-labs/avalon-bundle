require 'rails_helper'

RSpec.describe "active_encode_encode_records/edit", type: :view do
  before(:each) do
    @active_encode_encode_record = assign(:active_encode_encode_record, ActiveEncodeEncodeRecord.create!(
      :global_id => "MyString",
      :state => "MyString",
      :adapter => "MyString",
      :title => "MyString",
      :raw_object => "MyText"
    ))
  end

  it "renders the edit active_encode_encode_record form" do
    render

    assert_select "form[action=?][method=?]", active_encode_encode_record_path(@active_encode_encode_record), "post" do

      assert_select "input[name=?]", "active_encode_encode_record[global_id]"

      assert_select "input[name=?]", "active_encode_encode_record[state]"

      assert_select "input[name=?]", "active_encode_encode_record[adapter]"

      assert_select "input[name=?]", "active_encode_encode_record[title]"

      assert_select "textarea[name=?]", "active_encode_encode_record[raw_object]"
    end
  end
end
