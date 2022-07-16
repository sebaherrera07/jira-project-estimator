# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @jira_projects = jira_projects
  rescue StandardError => e
    raise e
  end

  private

  def jira_projects
    response = JiraApiClientService.new.query_projects
    projects = response['values']
    return ['No Projects'] if projects.empty?

    projects.map do |project|
      "Project - #{project['name']}"
    end
  end
end
