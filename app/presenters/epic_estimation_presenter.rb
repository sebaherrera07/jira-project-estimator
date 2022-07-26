# frozen_string_literal: true

class EpicEstimationPresenter
  def initialize(issues:, remaining_story_points:, implementation_start_date:)
    @issues = issues
    @remaining_story_points = remaining_story_points
    @implementation_start_date = implementation_start_date
  end

  def avg_story_points_per_week_since_beginning
    @avg_story_points_per_week_since_beginning ||= AverageStoryPointsCalculator.new(
      completed_issues: completed_issues,
      implementation_start_date: implementation_start_date
    ).calculate
  end

  def avg_story_points_per_week_since_last_3_weeks
    @avg_story_points_per_week_since_last_3_weeks ||= AverageStoryPointsCalculator.new(
      completed_issues: completed_issues,
      weeks_ago_since: 3,
      implementation_start_date: implementation_start_date
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

  attr_reader :issues, :remaining_story_points, :implementation_start_date

  def completed_issues
    @completed_issues ||= issues.select(&:done?)
  end

  def formatted_estimation(avg_story_points_per_week)
    weeks = (remaining_story_points / avg_story_points_per_week.to_f).round(1)
    date = Time.zone.today.beginning_of_week + weeks.weeks
    "#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})"
  end
end
