# frozen_string_literal: true

class ProgressController < ApplicationController
  def index
    @project_key = params[:project_id]
    @epic_key = params[:epic_id]
    epic_issues = jira_epic_issues(@project_key, @epic_key)
    @epic_progress_presenter = EpicProgressPresenter.new(issues: epic_issues)
    @epic_earned_value_presenter = EpicEarnedValuePresenter.new(
      completed_issues: completed_issues(epic_issues),
      total_story_points: @epic_progress_presenter.total_story_points
    )
  end

  private

  def jira_epic_issues(project_key, epic_key)
    JiraApiClientService.new.query_epic_issues(project_key, epic_key)
  end

  def completed_issues(epic_issues)
    epic_issues.select(&:done?)
  end
end