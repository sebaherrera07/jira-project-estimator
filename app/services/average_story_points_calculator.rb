# frozen_string_literal: true

class AverageStoryPointsCalculator
  def initialize(completed_issues:, weeks_ago_since: 0, project_start_date: nil)
    @completed_issues = completed_issues

    # Use 0 for 'since beginning'
    @weeks_ago_since = weeks_ago_since

    # If known, it's more accurate to pass it via param
    @project_start_date = project_start_date || calculated_project_start_date
  end

  def calculate
    return 0 if completed_estimated_issues.empty? || number_of_weeks_in_period.zero?

    (completed_estimated_issues_in_selected_period.sum(&:story_points) / (number_of_weeks_in_period * 1.0)).round(1)
  end

  private

  attr_reader :completed_issues, :weeks_ago_since, :project_start_date

  def calculated_project_start_date
    @calculated_project_start_date ||= ProjectStartDateCalculator.new(issues: completed_issues).calculate
  end

  def completed_estimated_issues
    @completed_estimated_issues ||= completed_issues.select(&:estimated?)
  end

  def completed_estimated_issues_in_selected_period
    completed_estimated_issues.select do |issue|
      issue.finish_date >= period_start_date &&
        issue.finish_date <= period_end_date
    end
  end

  def number_of_weeks_in_period
    @number_of_weeks_in_period ||= period_start_date.step(period_end_date, 7).count
  end

  def period_end_date
    # For calculating average, do not include current week.
    @period_end_date ||= Time.zone.today.beginning_of_week - 1.day
  end

  def period_start_date
    @period_start_date ||=
      if weeks_ago_since.zero? || weeks_ago_previous_than_project_start_date?
        project_start_date.beginning_of_week
      else
        weeks_ago_week_start_date
      end
  end

  def weeks_ago_previous_than_project_start_date?
    weeks_ago_week_start_date < project_start_date.beginning_of_week
  end

  def weeks_ago_week_start_date
    @weeks_ago_week_start_date ||= Time.zone.today.beginning_of_week - weeks_ago_since.weeks
  end
end
