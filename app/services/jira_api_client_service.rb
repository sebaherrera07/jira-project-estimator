# frozen_string_literal: true

class JiraApiClientService
  def jira_client
    @jira_client ||= JIRA::Client.new(jira_options)
  end

  private

  def jira_options
    {
      username: ENV.fetch('JIRA_USERNAME'),
      site: ENV.fetch('JIRA_SITE_URL'),
      context_path: '',
      auth_type: :basic,
      default_headers: { 'Authorization' => "Bearer #{ENV.fetch('JIRA_API_TOKEN')}" }
    }
  end
end
