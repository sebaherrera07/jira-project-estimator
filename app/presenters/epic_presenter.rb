# frozen_string_literal: true

class EpicPresenter
  attr_reader :epic, :issues

  def initialize(epic:, issues:, implementation_start_date: nil)
    @epic = epic
    @issues = issues
    @implementation_start_date = implementation_start_date
  end

  delegate :key, :labels, :project_key, :summary, to: :epic

  def issues_count_presenter
    @issues_count_presenter ||= EpicIssuesCountPresenter.new(issues: issues)
  end

  def progress_presenter
    @progress_presenter ||= EpicProgressPresenter.new(
      issues: issues,
      implementation_start_date: implementation_start_date
    )
  end

  def estimation_presenter
    @estimation_presenter ||= EpicEstimationPresenter.new(
      issues: issues,
      remaining_story_points: progress_presenter.remaining_story_points,
      implementation_start_date: progress_presenter.implementation_start_date
    )
  end

  private

  attr_reader :implementation_start_date
end
