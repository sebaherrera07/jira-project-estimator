# frozen_string_literal: true

class EstimatedFinishDateCalculator
  def initialize(remaining_story_points:, avg_story_points_per_week:, uncertainty_percentage:)
    @remaining_story_points = remaining_story_points
    @avg_story_points_per_week = avg_story_points_per_week
    @uncertainty_percentage = uncertainty_percentage
  end

  def weeks_lower_value
    @weeks_lower_value ||= (remaining_story_points / avg_story_points_per_week.to_f).round(1)
  end

  def date_lower_value
    @date_lower_value ||= beginning_of_week + weeks_lower_value.weeks
  end

  def weeks_higher_value
    @weeks_higher_value ||= begin
      possible_remaining_story_points = remaining_story_points * uncertainty_rate
      (possible_remaining_story_points / avg_story_points_per_week.to_f).round(1)
    end
  end

  def date_higher_value
    @date_higher_value ||= beginning_of_week + weeks_higher_value.weeks
  end

  private

  attr_reader :remaining_story_points, :avg_story_points_per_week, :uncertainty_percentage

  def beginning_of_week
    @beginning_of_week ||= Time.zone.today.beginning_of_week
  end

  def uncertainty_rate
    @uncertainty_rate ||= 1 + (uncertainty_percentage / 100.0)
  end
end
