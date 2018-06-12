module Avalon
  class ManifestRange
    attr_reader :label, :items

    def initialize(label:, items: [])
      @label = label
      @items = items
    end
  end
end
