# frozen_string_literal: true

module EpicDetails
  extend ActiveSupport::Concern

  private

  def epic
    jira_project_epic(project_key, epic_key)
  end

  def epic_issues
    jira_epic_issues(project_key, epic_key, labels)
  end

  def epic_key
    @epic_key ||= params[:epic_id] || params[:id]
  end

  def epic_presenter
    EpicPresenter.new(
      epic: epic,
      issues: epic_issues,
      expected_average: expected_average,
      uncertainty_level: uncertainty_level,
      labels_filter: labels_filter
    )
  end

  def expected_average
    # If it's nil or it's not a number, returns 0.0
    params[:expected_average].to_f
  end

  def jira_api_client_service
    @jira_api_client_service ||= JiraApiClientService.new
  end

  def jira_project_epic(project_key, epic_key)
    jira_api_client_service.query_project_epic(project_key, epic_key)
  end

  def jira_epic_issues(project_key, epic_key, labels)
    jira_api_client_service.query_epic_issues(project_key, epic_key, labels)
  end

  def labels
    return if params[:labels].blank?

    params[:labels].is_a?(Array) ? params[:labels] : [params[:labels]]
  end

  def project_key
    @project_key ||= params[:project_id]
  end

  def uncertainty_level
    params[:uncertainty_level]
  end

  def labels_filter
    params[:labels]
  end
end
