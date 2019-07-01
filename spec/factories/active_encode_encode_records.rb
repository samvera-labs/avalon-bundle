# frozen_string_literal: true

FactoryBot.define do
  factory :active_encode_encode_record do
    global_id { "Global" }
    state { "State" }
    adapter { "Adapter" }
    title { "Title" }
    raw_object { "MyText" }
  end
end
