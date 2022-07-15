# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @jira_projects = jira_projects
  rescue StandardError => e
    raise e
  end

  private

  def jira_projects
    jira_client = JiraApiClientService.new.jira_client
    projects = jira_client.Project.all
    return ['No Projects'] if projects.empty?

    projects.map do |project|
      "Project - #{project}"
    end
  end
end
