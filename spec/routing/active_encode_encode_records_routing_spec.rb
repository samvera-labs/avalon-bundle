# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActiveEncodeEncodeRecordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/active_encode_encode_records").to route_to("active_encode_encode_records#index")
    end

    it "routes to #show" do
      expect(get: "/active_encode_encode_records/1").to route_to("active_encode_encode_records#show", id: "1")
    end
  end
end
