# frozen_string_literal: true

FactoryBot.define do
  factory :estimation do
    avg_weekly_earned_value { [1.5, 2.0, 3.2, 4.6, 8.3].sample }
    sequence(:epic_id) { |n| "EPIC-#{n}" }
    estimated_finish_date { Time.zone.now.beginning_of_week + remaining_weeks.weeks }
    estimated_finish_date_with_uncertainty { estimated_finish_date }
    filters_applied { nil }
    last_completed_week_number { [1, 2, 3, 4].sample }
    remaining_earned_value { [20.0, 32.0, 44.2, 61.7].sample }
    remaining_weeks { [0.8, 1.3, 2.5, 3.0, 6.3].sample }
    total_points { [15, 25, 73, 81, 105, 230].sample }
    uncertainty_level { nil }

    trait :with_user do
      user
    end

    trait :with_uncertainty do
      estimated_finish_date_with_uncertainty { estimated_finish_date + 2.weeks }
      uncertainty_level { UncertaintyLevel::LEVELS.keys.sample }
    end
  end
end
