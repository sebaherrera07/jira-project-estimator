# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    key { name.upcase.first(4) }
    name { Faker::Lorem.word.capitalize }

    initialize_with { new(attributes) }
  end
end
