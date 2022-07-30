# frozen_string_literal: true

class IssuesController < ApplicationController
  def index
    @project_key = params[:project_id]
    @epic_key = params[:epic_id]
    epic = jira_project_epic(@project_key, @epic_key)
    epic_issues = jira_epic_issues(@project_key, @epic_key, params[:labels])
    @epic_presenter = EpicPresenter.new(
      epic: epic,
      issues: epic_issues
    )
  end

  private

  def jira_project_epic(project_key, epic_key)
    jira_api_client_service.query_project_epic(project_key, epic_key)
  end

  def jira_epic_issues(project_key, epic_key, labels)
    jira_api_client_service.query_epic_issues(project_key, epic_key, labels)
  end

  def jira_api_client_service
    @jira_api_client_service ||= JiraApiClientService.new
  end
end
