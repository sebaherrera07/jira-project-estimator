# frozen_string_literal: true

class UncertaintyLevel
  LOW = :low
  MEDIUM = :medium
  HIGH = :high
  VERY_HIGH = :very_high

  LEVELS = {
    LOW => 0,
    MEDIUM => 1,
    HIGH => 2,
    VERY_HIGH => 3
  }.with_indifferent_access.freeze

  attr_reader :level

  def initialize(level)
    @level = level&.to_sym
  end

  def to_s
    level&.to_s&.humanize
  end

  def percentage
    @percentage ||=
      case level
      when LOW then ENV['LOW_UNCERTAINTY_PERCENTAGE'].to_f
      when MEDIUM then ENV['MEDIUM_UNCERTAINTY_PERCENTAGE'].to_f
      when HIGH then ENV['HIGH_UNCERTAINTY_PERCENTAGE'].to_f
      when VERY_HIGH then ENV['VERY_HIGH_UNCERTAINTY_PERCENTAGE'].to_f
      else
        0
      end
  end
end
