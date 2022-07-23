# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    created_date { Time.zone.now }
    sequence(:epic_key) { |n| "#{project_key}-#{n}" }
    sequence(:key) { |n| "#{project_key}-#{n + 1}" }
    labels { [] }
    project_key { Faker::Lorem.word.upcase.first(4) }
    status { ['To Do', 'In Progress', 'Done', 'Other'].sample }
    status_category_change_date { Time.zone.now }
    story_points { [1, 2, 3, 5, 8, 13].sample }
    summary { 'Summary' }

    initialize_with { new(attributes) }

    trait :to_do do
      status { 'To Do' }
    end

    trait :in_progress do
      status { 'In Progress' }
    end

    trait :done do
      status { 'Done' }
    end

    trait :with_labels do
      labels { %w[label-1 label-2] }
    end

    trait :unestimated do
      story_points { nil }
    end

    trait :without_epic do
      epic_key { nil }
    end
  end
end
