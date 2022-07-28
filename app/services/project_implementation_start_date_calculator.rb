# frozen_string_literal: true

class ProjectImplementationStartDateCalculator
  def initialize(issues:)
    @issues = issues
  end

  def calculate
    return if first_status_changed_issue.blank?

    # Might not be 100% accurate, but it's something.
    first_status_changed_issue.status_change_date.to_date
  end

  private

  attr_reader :issues

  def issues_with_status_change_date
    @issues_with_status_change_date ||=
      issues.select { |issue| issue.status_change_date.present? }
  end

  def first_status_changed_issue
    @first_status_changed_issue ||= issues_with_status_change_date.min_by(&:status_change_date)
  end
end
