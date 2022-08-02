# frozen_string_literal: true

FactoryBot.define do
  factory :earned_value_item do
    completed_issue { build(:issue, :done) }
    previous_cumulative_earned_value { Faker::Number.within(range: 0..50) }
    total_story_points { Faker::Number.within(range: 10..200) }
    implementation_start_date { 5.weeks.ago.beginning_of_week.to_date }

    initialize_with do
      new(
        completed_issue: completed_issue,
        previous_cumulative_earned_value: previous_cumulative_earned_value,
        total_story_points: total_story_points,
        implementation_start_date: implementation_start_date
      )
    end
  end
end
