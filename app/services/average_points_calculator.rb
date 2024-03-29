# frozen_string_literal: true

class AveragePointsCalculator
  def initialize(completed_issues:, implementation_start_date:, weeks_ago_since: 0)
    @completed_issues = completed_issues
    @implementation_start_date = implementation_start_date
    @weeks_ago_since = weeks_ago_since # Use 0 for 'since beginning'
  end

  def calculate
    return 0 if completed_estimated_issues.empty? || number_of_weeks_in_period.zero?

    (completed_estimated_issues_in_selected_period.sum(&:points) / number_of_weeks_in_period.to_f).round(1)
  end

  private

  attr_reader :completed_issues, :weeks_ago_since, :implementation_start_date

  def completed_estimated_issues
    @completed_estimated_issues ||= completed_issues.select(&:estimated?)
  end

  def completed_estimated_issues_in_selected_period
    completed_estimated_issues.select do |issue|
      issue.finish_date >= period_start_date &&
        issue.finish_date <= period_end_date.end_of_day
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
      if weeks_ago_since.zero? || weeks_ago_previous_than_implementation_start_date?
        implementation_start_date.beginning_of_week
      else
        weeks_ago_week_start_date
      end
  end

  def weeks_ago_previous_than_implementation_start_date?
    weeks_ago_week_start_date < implementation_start_date.beginning_of_week
  end

  def weeks_ago_week_start_date
    @weeks_ago_week_start_date ||= Time.zone.today.beginning_of_week - weeks_ago_since.weeks
  end
end
