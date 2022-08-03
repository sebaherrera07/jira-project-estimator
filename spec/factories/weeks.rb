# frozen_string_literal: true

FactoryBot.define do
  factory :week do
    number { [1, 2, 3, 4].sample }
    start_date { 5.weeks.ago.beginning_of_week.to_date }

    initialize_with do
      new(
        number: number,
        start_date: start_date
      )
    end
  end
end
