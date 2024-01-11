# frozen_string_literal: true

class EstimationCategory
  PESSIMISTIC = :pessimistic
  NEUTRAL = :neutral
  OPTIMISTIC = :optimistic
  ACTUAL_SINCE_BEGINNING = :actual_since_beginning
  ACTUAL_SINCE_LAST_3_WEEKS = :actual_since_last_3_weeks

  CATEGORIES = {
    PESSIMISTIC => 0,
    NEUTRAL => 1,
    OPTIMISTIC => 2,
    ACTUAL_SINCE_BEGINNING => 3,
    ACTUAL_SINCE_LAST_3_WEEKS => 4
  }.with_indifferent_access.freeze

  def self.dropdown_options
    CATEGORIES.except(ACTUAL_SINCE_BEGINNING, ACTUAL_SINCE_LAST_3_WEEKS).keys.map do |category|
      [category.humanize, category]
    end
  end
end
