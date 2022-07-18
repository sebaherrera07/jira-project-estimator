# frozen_string_literal: true

class IssuesController < ApplicationController
  def index
    @jira_epic_issues = jira_epic_issues(params[:project_id], params[:epic_id])
  rescue StandardError => e
    raise e
  end

  private

  def jira_epic_issues(project_key, epic_key)
    JiraApiClientService.new.query_epic_issues(project_key, epic_key)
  end
end
