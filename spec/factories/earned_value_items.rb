# frozen_string_literal: true

FactoryBot.define do
  factory :earned_value_item do
    completed_issue { build(:issue, :done) }
    previous_cumulative_earned_value { Faker::Number.within(range: 0..50) }
    total_story_points { Faker::Number.within(range: 10..200) }

    initialize_with do
      new(
        completed_issue: completed_issue,
        previous_cumulative_earned_value: previous_cumulative_earned_value,
        total_story_points: total_story_points
      )
    end
  end
end
