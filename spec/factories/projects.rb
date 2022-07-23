# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    key { 'PRO' }
    name { 'PROJECT-1' }

    initialize_with { new(attributes) }
  end
end
