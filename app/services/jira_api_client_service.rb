# frozen_string_literal: true

class JiraApiClientService
  def query_projects
    HTTParty.get("#{BASE_URL}project/search", request_params)
  end

  private

  BASE_URL = "#{ENV.fetch('JIRA_SITE_URL')}rest/api/3/".freeze

  def request_params
    {
      headers: { 'Accept' => 'application/json' },
      basic_auth: {
        username: ENV.fetch('JIRA_USERNAME'),
        password: ENV.fetch('JIRA_API_TOKEN')
      }
    }
  end
end
