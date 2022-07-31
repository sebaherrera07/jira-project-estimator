# frozen_string_literal: true

class ProgressController < ApplicationController
  def index
    @project_key = params[:project_id]
    @epic_key = params[:epic_id]
    epic = jira_project_epic(@project_key, @epic_key)
    epic_issues = jira_epic_issues(@project_key, @epic_key, labels)
    @epic_presenter = EpicPresenter.new(
      epic: epic,
      issues: epic_issues,
      implementation_start_date: implementation_start_date
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

  def implementation_start_date
    return if params[:implementation_start_date].blank?

    Date.strptime(params[:implementation_start_date], '%Y-%m-%d')
  end

  def labels
    return if params[:labels].blank?

    params[:labels].is_a?(Array) ? params[:labels] : [params[:labels]]
  end
end
