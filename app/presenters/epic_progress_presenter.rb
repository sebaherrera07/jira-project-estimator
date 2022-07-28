# frozen_string_literal: true

class EpicProgressPresenter
  attr_reader :implementation_start_date

  def initialize(issues:, implementation_start_date: nil)
    @issues = issues
    @implementation_start_date = (implementation_start_date || implementation_calculated_start_date)&.beginning_of_week
  end

  def total_story_points
    @total_story_points ||= estimated_issues.sum(&:story_points)
  end

  def completed_story_points
    @completed_story_points ||= completed_estimated_issues.sum(&:story_points)
  end

  def remaining_story_points
    @remaining_story_points ||= total_story_points - completed_story_points
  end

  def earned_value
    @earned_value ||= "#{earned_value_number}%"
  end

  def remaining_earned_value
    @remaining_earned_value ||= "#{100 - earned_value_number}%"
  end

  def unestimated_issues_count
    @unestimated_issues_count ||= unestimated_issues.count
  end

  def any_unestimated_issues?
    @any_unestimated_issues ||= unestimated_issues.any?
  end

  def completed_weeks_since_beginning
    return 0 if implementation_start_date.blank?

    @completed_weeks_since_beginning ||= implementation_start_date.step(
      Time.zone.today.beginning_of_week - 1.day, 7
    ).count
  end

  private

  attr_reader :issues

  def estimated_issues
    @estimated_issues ||= issues.select(&:estimated?)
  end

  def unestimated_issues
    @unestimated_issues ||= issues.reject(&:estimated?)
  end

  def completed_issues
    @completed_issues ||= issues.select(&:done?)
  end

  def completed_estimated_issues
    @completed_estimated_issues ||= estimated_issues.intersection(completed_issues)
  end

  def earned_value_number
    return 0 if total_story_points.zero?

    @earned_value_number ||= begin
      ratio = completed_story_points / total_story_points.to_f
      (ratio * 100).round
    end
  end

  def implementation_calculated_start_date
    @implementation_calculated_start_date ||= ProjectImplementationStartDateCalculator.new(issues: issues).calculate
  end
end
