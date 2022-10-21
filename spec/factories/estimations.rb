# frozen_string_literal: true

FactoryBot.define do
  factory :estimation do
    avg_weekly_earned_value { [1.5, 2.0, 3.2, 4.6, 8.3].sample }
    sequence(:epic_id) { |n| "EPIC-#{n}" }
    filters_applied { nil }
    last_completed_week_number { [1, 2, 3, 4].sample }
    project_id { Faker::Lorem.word.upcase.first(4) }
    remaining_earned_value { [20.0, 32.0, 44.2, 61.7].sample }
    remaining_weeks { [0.8, 1.3, 2.5, 3.0, 6.3].sample }
    total_points { [15, 25, 73, 81, 105, 230].sample }
    uncertainty_level { nil }
    uncertainty_percentage { nil }

    trait :with_user do
      user
    end

    trait :with_uncertainty do
      remaining_weeks_with_uncertainty { remaining_weeks + 2 }
      uncertainty_level { UncertaintyLevel::LEVELS.keys.sample }
      uncertainty_percentage { UncertaintyLevel.new(uncertainty_level).percentage }
    end
  end
end
