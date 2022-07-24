# frozen_string_literal: true

class EpicIssuesCountPresenter
  def initialize(issues = [])
    @issues = issues
  end

  def total_issues_count
    @total_issues_count ||= issues.count
  end

  def completed_issues_count
    @completed_issues_count ||= completed_issues.count
  end

  def remaining_issues_count
    @remaining_issues_count ||= total_issues_count - completed_issues_count
  end

  def started_issues_count
    @started_issues_count ||= started_issues.count
  end

  def unestimated_issues_count
    @unestimated_issues_count ||= unestimated_issues.count
  end

  private

  attr_reader :issues

  def unestimated_issues
    @unestimated_issues ||= issues.reject(&:estimated?)
  end

  def completed_issues
    @completed_issues ||= issues.select(&:done?)
  end

  def started_issues
    @started_issues ||= issues.select(&:started?)
  end
end
