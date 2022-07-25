# frozen_string_literal: true

class EpicEstimationPresenter
  def initialize(issues:)
    @issues = issues
  end

  def avg_story_points_per_week_since_beginning
    project_start_date = nil # If known, it's more accurate to pass it via param
    @avg_story_points_per_week_since_beginning ||= AverageStoryPointsCalculator.new(
      completed_issues: completed_issues,
      project_start_date: project_start_date
    ).calculate
  end

  def avg_story_points_per_week_since_last_3_weeks
    project_start_date = nil # If known, it's more accurate to pass it via param
    @avg_story_points_per_week_since_last_3_weeks ||= AverageStoryPointsCalculator.new(
      completed_issues: completed_issues,
      weeks_ago_since: 3,
      project_start_date: project_start_date
    ).calculate
  end

  def estimated_weeks_to_complete_using_since_beggining_avg
    return "Avg is 0. Can't generate estimation." if avg_story_points_per_week_since_beginning.zero?

    @estimated_weeks_to_complete_using_since_beggining_avg ||=
      formatted_estimation(avg_story_points_per_week_since_beginning)
  end

  def estimated_weeks_to_complete_using_since_last_3_weeks_avg
    return "Avg is 0. Can't generate estimation." if avg_story_points_per_week_since_last_3_weeks.zero?

    @estimated_weeks_to_complete_using_since_last_3_weeks_avg ||=
      formatted_estimation(avg_story_points_per_week_since_last_3_weeks)
  end

  private

  attr_reader :issues

  def completed_issues
    @completed_issues ||= issues.select(&:done?)
  end

  def formatted_estimation(avg_story_points_per_week)
    weeks = (remaining_story_points / (avg_story_points_per_week * 1.0)).round(1)
    date = Time.zone.today.beginning_of_week + weeks.weeks
    "#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})"
  end

  def remaining_story_points
    # TODO: avoid duplicating this
    @remaining_story_points ||= total_story_points - completed_story_points
  end

  def total_story_points
    @total_story_points ||= estimated_issues.sum(&:story_points)
  end

  def completed_story_points
    # TODO: consider only up to previous week for progress and estimations?
    @completed_story_points ||= completed_estimated_issues.sum(&:story_points)
  end

  def estimated_issues
    @estimated_issues ||= issues.select(&:estimated?)
  end

  def completed_estimated_issues
    @completed_estimated_issues ||= estimated_issues.intersection(completed_issues)
  end
end
