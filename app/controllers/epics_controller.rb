# frozen_string_literal: true

class EpicsController < ApplicationController
  include ::EpicDetails

  def index
    @epics = jira_project_epics(project_key)
  end

  def show
    @epic_presenter = epic_presenter
  end

  private

  def jira_project_epics(project_key)
    jira_api_client_service.query_project_epics(project_key).sort_by(&:summary)
  end
end
