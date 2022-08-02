# frozen_string_literal: true

FactoryBot.define do
  factory :weekly_earned_value_item do
    earned_value_items { [build_list(:earned_value_item, 2)] }
    previous_cumulative_earned_value { Faker::Number.within(range: 0..50) }
    week { build(:week) }

    initialize_with do
      new(
        earned_value_items: earned_value_items,
        previous_cumulative_earned_value: previous_cumulative_earned_value,
        week: week
      )
    end
  end
end
