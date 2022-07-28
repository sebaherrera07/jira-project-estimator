# frozen_string_literal: true

class ProgressController < ApplicationController
  def index
    @project_key = params[:project_id]
    @epic_key = params[:epic_id]
    epic_issues = jira_epic_issues(@project_key, @epic_key, params[:labels])
    @epic_progress_presenter = EpicProgressPresenter.new(
      issues: epic_issues,
      implementation_start_date: implementation_start_date
    )
    @epic_earned_value_presenter = EpicEarnedValuePresenter.new(
      completed_issues: completed_issues(epic_issues),
      total_story_points: @epic_progress_presenter.total_story_points
    )
  end

  private

  def jira_epic_issues(project_key, epic_key)
    JiraApiClientService.new.query_epic_issues(project_key, epic_key, labels)
  end

  def completed_issues(epic_issues)
    epic_issues.select(&:done?)
  end

  def implementation_start_date
    return if params[:implementation_start_date].blank?

    Date.strptime(params[:implementation_start_date], '%Y-%m-%d')
  end
end
