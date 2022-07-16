# frozen_string_literal: true

class EpicsController < ApplicationController
  def show
    @jira_epic_issues = jira_epic_issues(params[:project_id], params[:id])
  rescue StandardError => e
    raise e
  end

  private

  def jira_epic_issues(project_key, epic_key)
    issues = JiraApiClientService.new.query_epic_issues(project_key, epic_key)
    return ['No Issues'] if issues.empty?

    issues.map do |issue|
      "Issue - #{issue.summary} (#{issue.key})"
    end
  end
end
