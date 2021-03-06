# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @projects = jira_projects
  end

  private

  def jira_projects
    JiraApiClientService.new.query_projects
  end
end
