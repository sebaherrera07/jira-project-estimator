# frozen_string_literal: true

class EstimationCategory
  PESSIMISTIC = :pessimistic
  NEUTRAL = :neutral
  OPTIMISTIC = :optimistic
  AVERAGE_SINCE_BEGINNING = :avg_since_beginning
  AVERAGE_LAST_3_WEEKS = :avg_last_3_weeks

  CATEGORIES = {
    PESSIMISTIC => 0,
    NEUTRAL => 1,
    OPTIMISTIC => 2,
    AVERAGE_SINCE_BEGINNING => 3,
    AVERAGE_LAST_3_WEEKS => 4
  }.with_indifferent_access.freeze

  CATEGORIES_TITLE = {
    PESSIMISTIC => PESSIMISTIC.to_s.humanize,
    NEUTRAL => NEUTRAL.to_s.humanize,
    OPTIMISTIC => OPTIMISTIC.to_s.humanize,
    AVERAGE_SINCE_BEGINNING => 'Avg. since beginning',
    AVERAGE_LAST_3_WEEKS => 'Avg. last 3 weeks'
  }.with_indifferent_access.freeze

  def self.dropdown_options
    [NEUTRAL, PESSIMISTIC, OPTIMISTIC].map do |category|
      [CATEGORIES_TITLE[category], category.to_s]
    end
  end
end
