# frozen_string_literal: true

class EpicProgressPresenter
  def initialize(issues:)
    @issues = issues
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

  private

  attr_reader :issues

  def estimated_issues
    @estimated_issues ||= issues.select(&:estimated?)
  end

  def unestimated_issues
    @unestimated_issues ||= issues.reject(&:estimated?)
  end

  def completed_issues
    # TODO: consider only up to previous week for progress and estimations?
    @completed_issues ||= issues.select(&:done?)
  end

  def completed_estimated_issues
    @completed_estimated_issues ||= estimated_issues.intersection(completed_issues)
  end

  def earned_value_number
    return 0 if total_story_points.zero?

    @earned_value_number ||= begin
      ratio = completed_story_points / (total_story_points * 1.0)
      (ratio * 100).round
    end
  end
end
