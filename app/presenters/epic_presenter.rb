# frozen_string_literal: true

class EpicPresenter
  attr_reader :epic, :issues

  def initialize(epic:, issues:)
    @epic = epic
    @issues = issues
  end

  delegate :key, :labels, :project_key, :summary, to: :epic

  delegate :total_issues_count,
           :completed_issues_count,
           :remaining_issues_count,
           :started_issues_count,
           :unestimated_issues_count,
           to: :issues_count_presenter

  delegate :total_story_points,
           :completed_story_points,
           :remaining_story_points,
           :earned_value,
           :remaining_earned_value,
           :any_unestimated_issues?,
           to: :progress_presenter

  delegate :avg_story_points_per_week_since_beginning,
           :avg_story_points_per_week_since_last_3_weeks,
           :estimated_weeks_to_complete_using_since_beggining_avg,
           :estimated_weeks_to_complete_using_since_last_3_weeks_avg,
           to: :estimation_presenter

  private

  def issues_count_presenter
    @issues_count_presenter ||= EpicIssuesCountPresenter.new(issues: issues)
  end

  def progress_presenter
    @progress_presenter ||= EpicProgressPresenter.new(issues: issues)
  end

  def estimation_presenter
    @estimation_presenter ||= EpicEstimationPresenter.new(issues: issues)
  end
end
