# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "active_encode_encode_records/show", type: :view do
  before do
    @active_encode_encode_record = assign(:active_encode_encode_record,
                                          ActiveEncodeEncodeRecord.create!(
                                            global_id: "Global",
                                            state: "State",
                                            adapter: "Adapter",
                                            title: "Title",
                                            raw_object: "MyText"
                                          ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Global/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Adapter/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
