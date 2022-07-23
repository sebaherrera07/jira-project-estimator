# frozen_string_literal: true

FactoryBot.define do
  factory :epic do
    sequence(:key) { |n| "#{project_key}-#{n}" }
    labels { [] }
    project_key { Faker::Lorem.word.upcase.first(4) }
    summary { Faker::Lorem.sentence(word_count: 3) }

    initialize_with { new(attributes) }
  end
end
