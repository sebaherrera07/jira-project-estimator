# frozen_string_literal: true

class JiraApiMocker
  def stub_query_projects
    url = "#{BASE_URL}/project/search"
    stub_request(url, request_params).to_return(
      status: 200,
      body: {
        'values' => [
          {
            'key' => 'PA',
            'name' => 'Project A'
          },
          {
            'key' => 'PB',
            'name' => 'Project B'
          }
        ]
      }.to_json
    )
  end

  private

  BASE_URL = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3".freeze

  def stub_request(url, query_params = {})
    WebMock.stub_request(:get, url).with(
      request_params(query_params)
    )
  end

  def request_params(query_params = {})
    {
      headers: { 'Accept' => 'application/json' },
      basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')]
    }.merge(query_params)
  end
end
