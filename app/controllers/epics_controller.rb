# frozen_string_literal: true

class EpicsController < ApplicationController
  def index
    @jira_project_epics = jira_project_epics(params[:project_id])
  rescue StandardError => e
    raise e
  end

  private

  def jira_project_epics(project_key)
    JiraApiClientService.new.query_project_epics(project_key)
  end
end
