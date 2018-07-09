require 'rspec'

RSpec.describe HyraxHelper, type: :helper do
  describe "#capitalize_value" do
    let(:value) { 'test state' }
    it "returns a string with the value capitalized" do
      expect(helper.capitalize_value(value)).to eq('Test State')
    end
  end
end
