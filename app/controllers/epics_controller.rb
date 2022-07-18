# frozen_string_literal: true

class EpicsController < ApplicationController
  def index
    @epics = jira_project_epics(params[:project_id])
  end

  def show
    epic = jira_project_epic(params[:project_id], params[:id])
    epic_issues = jira_epic_issues(params[:project_id], params[:id])
    @epic_presenter = EpicPresenter.new(epic, epic_issues)
  end

  private

  def jira_project_epics(project_key)
    jira_api_client_service.query_project_epics(project_key)
  end

  def jira_project_epic(project_key, epic_key)
    jira_api_client_service.query_project_epic(project_key, epic_key)
  end

  def jira_epic_issues(project_key, epic_key)
    jira_api_client_service.query_epic_issues(project_key, epic_key)
  end

  def jira_api_client_service
    @jira_api_client_service ||= JiraApiClientService.new
  end
end
