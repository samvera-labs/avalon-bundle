# frozen_string_literal: true

module RuboCop
  module Cop
    module Avalon
      class LicenseHeader < Cop
        MSG = 'Must include license header.'.freeze

        def investigate(processed_source)
          has_header = processed_source.comments.any? { |c| c.start_with? "Copyright" }
          add_offense(processed_source.ast) unless has_header
        end
      end
    end
  end
end
