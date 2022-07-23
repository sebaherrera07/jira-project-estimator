# frozen_string_literal: true

FactoryBot.define do
  factory :epic do
    key { 'EPIC-1' }
    labels { [] }
    project_key { 'PRO' }
    status { 'To Do' }
    summary { 'Summary' }

    initialize_with { new(attributes) }
  end
end
