# frozen_string_literal: true

class JiraApiMocker
  def stub_query_projects
    url = "#{BASE_URL}/project/search"
    stub_request(url, request_params).to_return(
      status: 200,
      body: JiraApiResponses.query_projects_response_body
    )
  end

  def stub_query_project_epics(project_key)
    url = "#{BASE_URL}/search"
    query_params = {
      query: {
        jql: "project = #{project_key} AND issuetype = Epic",
        startAt: 0,
        maxResults: 100
      }
    }
    stub_request(url, request_params(query_params)).to_return(
      status: 200,
      body: JiraApiResponses.query_project_epics_response_body(project_key)
    )
  end

  def stub_query_project_epic(project_key, epic_key)
    url = "#{BASE_URL}/search"
    query_params = { query: { jql: "project = #{project_key} AND issuetype = Epic AND key = #{epic_key}" } }
    stub_request(url, request_params(query_params)).to_return(
      status: 200,
      body: JiraApiResponses.query_project_epic_response_body(project_key, epic_key)
    )
  end

  def stub_query_epic_issues(project_key, epic_key)
    url = "#{BASE_URL}/search"
    query_params = {
      query: {
        jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic",
        startAt: 0,
        maxResults: 100
      }
    }
    stub_request(url, request_params(query_params)).to_return(
      status: 200,
      body: JiraApiResponses.query_epic_issues_response_body(project_key, epic_key)
    )
  end

  def stub_query_epic_issues_with_labels(project_key, epic_key, labels)
    url = "#{BASE_URL}/search"
    query_params = { query: {
      jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic " \
           "AND labels in (#{labels.join(',')})",
      startAt: 0,
      maxResults: 100
    } }
    stub_request(url, request_params(query_params)).to_return(
      status: 200,
      body: JiraApiResponses.query_epic_issues_with_labels_response_body(project_key, epic_key, labels)
    )
  end

  def stub_query_epic_issues_with_custom_points_field(project_key, epic_key)
    url = "#{BASE_URL}/search"
    query_params = {
      query: {
        jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic",
        startAt: 0,
        maxResults: 100
      }
    }
    stub_request(url, request_params(query_params)).to_return(
      status: 200,
      body: JiraApiResponses.query_epic_issues_with_custom_points_field_response_body(project_key, epic_key)
    )
  end

  private

  BASE_URL = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3".freeze
  private_constant :BASE_URL

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
