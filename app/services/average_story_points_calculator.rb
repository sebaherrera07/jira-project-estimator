# frozen_string_literal: true

class AverageStoryPointsCalculator
  def initialize(completed_issues:, weeks_ago_since: 0, project_start_date: nil)
    @completed_issues = completed_issues

    # Use 0 for 'since beginning'
    @weeks_ago_since = weeks_ago_since

    # If known, it's more accurate to pass it via param
    @project_start_date = project_start_date
  end

  def calculate
    return 0 if completed_estimated_issues.empty? || number_of_weeks_in_period.zero?

    completed_estimated_issues_in_selected_period.sum(&:story_points) / number_of_weeks_in_period
  end

  private

  attr_reader :completed_issues, :weeks_ago_since, :project_start_date

  def calculated_project_start_date
    # Might not be very accurate, but it's something.
    @calculated_project_start_date ||= first_completed_issue.finish_date.to_date
  end

  def first_completed_issue
    @first_completed_issue ||= completed_issues.min_by(&:finish_date)
  end

  def completed_estimated_issues
    @completed_estimated_issues ||= completed_issues.select(&:estimated?)
  end

  def period_start_date
    return (project_start_date || calculated_project_start_date).beginning_of_week if weeks_ago_since.zero?

    Time.zone.today.beginning_of_week - weeks_ago_since.weeks
  end

  def period_end_date
    # For calculating average, do not include current week.
    Time.zone.today.beginning_of_week - 1.day
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
end
