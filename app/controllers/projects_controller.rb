# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @jira_projects = jira_projects
  rescue StandardError => e
    raise e
  end

  private

  def jira_projects
    JiraApiClientService.new.query_projects
  end
end
