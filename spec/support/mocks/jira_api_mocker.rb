# frozen_string_literal: true

class JiraApiMocker
  def stub_query_projects
    url = "#{BASE_URL}/project/search"
    WebMock.stub_request(:get, url).with(auth_params).to_return(
      status: 200,
      body: JiraApiResponses.query_projects_response_body
    )
  end

  def stub_query_project_epics(project_key)
    url = "#{BASE_URL}/search/jql"
    body = {
      jql: "project = #{project_key} AND issuetype = Epic",
      maxResults: 100,
      fields: epic_fields
    }.to_json
    WebMock.stub_request(:post, url).with(post_params(body)).to_return(
      status: 200,
      body: JiraApiResponses.query_project_epics_response_body(project_key)
    )
  end

  def stub_query_project_epic(project_key, epic_key)
    url = "#{BASE_URL}/search/jql"
    body = {
      jql: "project = #{project_key} AND issuetype = Epic AND key = #{epic_key}",
      maxResults: 1,
      fields: epic_fields
    }.to_json
    WebMock.stub_request(:post, url).with(post_params(body)).to_return(
      status: 200,
      body: JiraApiResponses.query_project_epic_response_body(project_key, epic_key)
    )
  end

  def stub_query_epic_issues(project_key, epic_key)
    url = "#{BASE_URL}/search/jql"
    body = {
      jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic",
      maxResults: 100,
      fields: issue_fields
    }.to_json
    WebMock.stub_request(:post, url).with(post_params(body)).to_return(
      status: 200,
      body: JiraApiResponses.query_epic_issues_response_body(project_key, epic_key)
    )
  end

  def stub_query_epic_issues_with_labels(project_key, epic_key, labels)
    url = "#{BASE_URL}/search/jql"
    body = {
      jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) " \
           "AND issuetype != Epic AND labels in (#{labels.join(',')})",
      maxResults: 100,
      fields: issue_fields
    }.to_json
    WebMock.stub_request(:post, url).with(post_params(body)).to_return(
      status: 200,
      body: JiraApiResponses.query_epic_issues_with_labels_response_body(project_key, epic_key, labels)
    )
  end

  def stub_query_epic_issues_with_custom_points_field(project_key, epic_key)
    url = "#{BASE_URL}/search/jql"
    body = {
      jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic",
      maxResults: 100,
      fields: issue_fields
    }.to_json
    WebMock.stub_request(:post, url).with(post_params(body)).to_return(
      status: 200,
      body: JiraApiResponses.query_epic_issues_with_custom_points_field_response_body(project_key, epic_key)
    )
  end

  private

  BASE_URL = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3".freeze
  private_constant :BASE_URL

  def auth_params
    {
      headers: { 'Accept' => 'application/json' },
      basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')]
    }
  end

  def post_params(body)
    {
      body: body,
      headers: {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json'
      },
      basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')]
    }
  end

  def epic_fields
    start_date_custom = ENV.fetch('JIRA_START_DATE_FIELD_CODES', '').split(',')
    (%w[summary labels project customfield_10015] + start_date_custom).uniq
  end

  def issue_fields
    points_custom = ENV.fetch('JIRA_STORY_POINTS_FIELD_CODES', '').split(',')
    (%w[summary labels project status created parent statuscategorychangedate
        customfield_10016] + points_custom).uniq
  end
end
