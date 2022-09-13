# frozen_string_literal: true

FactoryBot.define do
  factory :uncertainty_level do
    level { %i[low medium high very_high].sample }

    trait :nil do
      level { nil }
    end

    trait :low do
      level { :low }
    end

    trait :medium do
      level { :medium }
    end

    trait :high do
      level { :high }
    end

    trait :very_high do
      level { :very_high }
    end

    initialize_with do
      new(level)
    end
  end
end
