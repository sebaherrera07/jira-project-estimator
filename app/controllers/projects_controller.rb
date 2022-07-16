# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @jira_projects = jira_projects
  rescue StandardError => e
    raise e
  end

  def show
    @jira_project_epics = jira_project_epics(params[:id])
  rescue StandardError => e
    raise e
  end

  private

  def jira_projects
    projects = JiraApiClientService.new.query_projects
    return ['No Projects'] if projects.empty?

    projects.map do |project|
      "Project - #{project.name} (#{project.key})"
    end
  end

  def jira_project_epics(project_key)
    epics = JiraApiClientService.new.query_project_epics(project_key)
    return ['No Epics'] if epics.empty?

    epics.map do |epic|
      "Epic - #{epic.summary} (#{epic.key})"
    end
  end
end
