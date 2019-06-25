require "rails_helper"

RSpec.describe ActiveEncodeEncodeRecordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/active_encode_encode_records").to route_to("active_encode_encode_records#index")
    end

    it "routes to #new" do
      expect(:get => "/active_encode_encode_records/new").to route_to("active_encode_encode_records#new")
    end

    it "routes to #show" do
      expect(:get => "/active_encode_encode_records/1").to route_to("active_encode_encode_records#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/active_encode_encode_records/1/edit").to route_to("active_encode_encode_records#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/active_encode_encode_records").to route_to("active_encode_encode_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/active_encode_encode_records/1").to route_to("active_encode_encode_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/active_encode_encode_records/1").to route_to("active_encode_encode_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/active_encode_encode_records/1").to route_to("active_encode_encode_records#destroy", :id => "1")
    end
  end
end
