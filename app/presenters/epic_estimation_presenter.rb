# frozen_string_literal: true

class EpicEstimationPresenter
  def initialize(issues:, remaining_points:, implementation_start_date:, uncertainty_level:,
                 expected_average: nil)
    @issues = issues
    @remaining_points = remaining_points
    @implementation_start_date = implementation_start_date
    @uncertainty_level = uncertainty_level
    @expected_average = expected_average
  end

  def avg_points_per_week_expected
    return if expected_average.blank? || expected_average.zero? || expected_average.negative?

    @avg_points_per_week_expected ||= expected_average
  end

  def avg_points_per_week(weeks_ago_since: 0)
    AveragePointsCalculator.new(
      completed_issues: completed_issues,
      weeks_ago_since: weeks_ago_since,
      implementation_start_date: implementation_start_date
    ).calculate
  end

  def estimated_weeks_to_complete_without_uncertainty(weeks_ago_since: 0, use_expected: false)
    avg_points_per_week = if use_expected
                            avg_points_per_week_expected
                          else
                            avg_points_per_week(weeks_ago_since: weeks_ago_since)
                          end
    return "Avg is 0. Can't generate estimation." if avg_points_per_week.zero?

    estimated_finish_date_calculator = estimated_finish_date_calculator(avg_points_per_week)
    weeks = estimated_finish_date_calculator.weeks_lower_value
    date = estimated_finish_date_calculator.date_lower_value
    formatted_estimation(weeks, date)
  end

  def estimated_weeks_to_complete_with_uncertainty(weeks_ago_since: 0, use_expected: false)
    avg_points_per_week = if use_expected
                            avg_points_per_week_expected
                          else
                            avg_points_per_week(weeks_ago_since: weeks_ago_since)
                          end
    return "Avg is 0. Can't generate estimation." if avg_points_per_week.zero?

    estimated_finish_date_calculator = estimated_finish_date_calculator(avg_points_per_week)
    weeks = estimated_finish_date_calculator.weeks_higher_value
    date = estimated_finish_date_calculator.date_higher_value
    formatted_estimation(weeks, date)
  end

  def uncertainty_title
    @uncertainty_title ||= uncertainty_level.to_s
  end

  def uncertainty_percentage
    @uncertainty_percentage ||= uncertainty_level.percentage
  end

  private

  attr_reader :issues, :remaining_points, :implementation_start_date, :uncertainty_level, :expected_average

  def completed_issues
    @completed_issues ||= issues.select(&:done?)
  end

  def estimated_finish_date_calculator(avg_points_per_week)
    EstimatedFinishDateCalculator.new(
      remaining_points: remaining_points,
      avg_points_per_week: avg_points_per_week,
      uncertainty_percentage: uncertainty_level.percentage
    )
  end

  def formatted_estimation(weeks, date)
    "#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})"
  end
end
