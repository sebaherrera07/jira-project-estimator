# frozen_string_literal: true

class JiraApiClientService
  def query_projects
    response = HTTParty.get("#{BASE_URL}/project/search", request_params)
    response['values'].map do |project_hash|
      project(project_hash)
    end
  end

  def query_project_epics(project_key)
    requery_query_params = { query: { jql: "project = #{project_key} AND issuetype = Epic" } }
    response = HTTParty.get("#{BASE_URL}/search", request_params.merge(requery_query_params))
    response['issues'].map do |epic_hash|
      epic(epic_hash)
    end
  end

  def query_project_epic(project_key, epic_key)
    requery_query_params = { query: { jql: "project = #{project_key} AND issuetype = Epic AND key = #{epic_key}" } }
    response = HTTParty.get("#{BASE_URL}/search", request_params.merge(requery_query_params))
    epic_hash = response['issues'].first
    epic(epic_hash)
  end

  def query_epic_issues(project_key, epic_key)
    requery_query_params = { query: { jql: "project = #{project_key} AND parent = #{epic_key}" } }
    response = HTTParty.get("#{BASE_URL}/search", request_params.merge(requery_query_params))
    response['issues'].map do |issue_hash|
      issue(issue_hash)
    end
  end

  private

  BASE_URL = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3".freeze

  def request_params
    {
      headers: { 'Accept' => 'application/json' },
      basic_auth: {
        username: ENV.fetch('JIRA_USERNAME'),
        password: ENV.fetch('JIRA_API_TOKEN')
      }
    }
  end

  def project(project_hash)
    Project.new(
      key: project_hash['key'],
      name: project_hash['name']
    )
  end

  def epic(epic_hash)
    Epic.new(
      key: epic_hash['key'],
      labels: epic_hash.dig('fields', 'labels'),
      project_key: epic_hash.dig('fields', 'project', 'key'),
      status: epic_hash.dig('fields', 'status', 'name'),
      summary: epic_hash.dig('fields', 'summary')
    )
  end

  # rubocop:disable Metrics/MethodLength
  def issue(issue_hash)
    Issue.new(
      created_date: issue_hash.dig('fields', 'created'),
      epic_key: issue_hash.dig('fields', 'parent', 'key'),
      key: issue_hash['key'],
      labels: issue_hash.dig('fields', 'labels'),
      project_key: issue_hash.dig('fields', 'project', 'key'),
      status: issue_hash.dig('fields', 'status', 'name'),
      status_category_change_date: issue_hash.dig('fields', 'statuscategorychangedate'),
      story_points: issue_hash.dig('fields', 'customfield_10016'),
      summary: issue_hash.dig('fields', 'summary')
    )
  end
  # rubocop:enable Metrics/MethodLength
end
