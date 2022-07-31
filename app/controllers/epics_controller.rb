# frozen_string_literal: true

class EpicsController < ApplicationController
  def index
    @project_key = params[:project_id]
    @epics = jira_project_epics(@project_key)
  end

  def show
    @project_key = params[:project_id]
    @epic_key = params[:id]
    epic = jira_project_epic(@project_key, @epic_key)
    epic_issues = jira_epic_issues(@project_key, @epic_key, labels)
    @epic_presenter = EpicPresenter.new(
      epic: epic,
      issues: epic_issues,
      implementation_start_date: implementation_start_date,
      expected_average: expected_average
    )
  end

  private

  def jira_project_epics(project_key)
    jira_api_client_service.query_project_epics(project_key).sort_by(&:summary)
  end

  def jira_project_epic(project_key, epic_key)
    jira_api_client_service.query_project_epic(project_key, epic_key)
  end

  def jira_epic_issues(project_key, epic_key, labels)
    jira_api_client_service.query_epic_issues(project_key, epic_key, labels)
  end

  def jira_api_client_service
    @jira_api_client_service ||= JiraApiClientService.new
  end

  def labels
    return if params[:labels].blank?

    params[:labels].is_a?(Array) ? params[:labels] : [params[:labels]]
  end

  def implementation_start_date
    return if params[:implementation_start_date].blank?

    Date.strptime(params[:implementation_start_date], '%Y-%m-%d')
  end

  def expected_average
    # If it's nil or it's not a number, returns 0.0
    params[:expected_average].to_f
  end
end
