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
end
