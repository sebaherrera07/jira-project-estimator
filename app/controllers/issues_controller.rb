# frozen_string_literal: true

class IssuesController < ApplicationController
  def index
    @project_key = params[:project_id]
    @epic_key = params[:epic_id]
    @issues = jira_epic_issues(@project_key, @epic_key)
  end

  private

  def jira_epic_issues(project_key, epic_key)
    JiraApiClientService.new.query_epic_issues(project_key, epic_key)
  end
end
