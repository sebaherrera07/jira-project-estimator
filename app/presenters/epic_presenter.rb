# frozen_string_literal: true

class EpicPresenter
  attr_reader :epic, :issues

  def initialize(epic:, issues:, expected_average: nil, uncertainty_level: nil, labels_filter: nil)
    @epic = epic
    @issues = issues
    @expected_average = expected_average
    @uncertainty_level = uncertainty_level
    @labels_filter = labels_filter
  end

  delegate :key, :labels, :project_key, :summary, to: :epic

  def issues_sorted
    issues.sort_by do |issue|
      if issue.started?
        0
      elsif issue.to_do?
        1
      else
        issue.finish_date.to_i
      end
    end
  end

  def issues_count_presenter
    @issues_count_presenter ||= EpicIssuesCountPresenter.new(issues: issues)
  end

  def progress_presenter
    @progress_presenter ||= EpicProgressPresenter.new(
      issues: issues,
      implementation_start_date: epic.start_date
    )
  end

  def estimation_presenter
    @estimation_presenter ||= EpicEstimationPresenter.new(
      issues: issues,
      remaining_points: progress_presenter.remaining_points,
      implementation_start_date: progress_presenter.implementation_start_date,
      uncertainty_level: UncertaintyLevel.new(uncertainty_level),
      expected_average: expected_average
    )
  end

  def estimation_history_presenter
    @estimation_history_presenter ||= EpicEstimationHistoryPresenter.new(
      epic_id: epic.key,
      labels_filter: labels_filter
    )
  end

  def earned_value_presenter
    @earned_value_presenter ||= EpicEarnedValuePresenter.new(
      completed_issues: issues_count_presenter.completed_issues,
      total_points: progress_presenter.total_points,
      implementation_start_date: progress_presenter.implementation_start_date
    )
  end

  def weekly_earned_value_presenter
    @weekly_earned_value_presenter ||= EpicWeeklyEarnedValuePresenter.new(
      earned_value_items: earned_value_presenter.earned_value_items,
      implementation_start_date: progress_presenter.implementation_start_date
    )
  end

  private

  attr_reader :expected_average, :uncertainty_level, :labels_filter
end
