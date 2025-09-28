# frozen_string_literal: true

class JiraApiClientService
  def query_projects
    response = HTTParty.get("#{BASE_URL}/project/search", request_params)
    json_response = JSON.parse(response.body)
    json_response['values'].map do |project_hash|
      project(project_hash)
    end
  end

  def query_project_epics(project_key)
    jql_string = "project = #{project_key} AND issuetype = Epic"

    epics = []
    start_at = 0
    total = 1

    while start_at < total
      start_at, total, epics = query_epics_page(jql_string, start_at, epics)
    end

    epics
  end

  def query_project_epic(project_key, epic_key)
    request_query_params = { query: { jql: "project = #{project_key} AND issuetype = Epic AND key = #{epic_key}" } }
    response = HTTParty.get("#{BASE_URL}/search", request_params.merge(request_query_params))
    json_response = JSON.parse(response.body)
    epic_hash = json_response['issues'].first
    epic(epic_hash)
  end

  def query_epic_issues(project_key, epic_key, labels = [])
    jql_string = "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic"
    jql_string += " AND labels in (#{labels.join(',')})" if labels.present?

    issues = []
    start_at = 0
    total = 1

    while start_at < total
      start_at, total, issues = query_issues_page(jql_string, start_at, issues)
    end

    issues
  end

  private

  BASE_URL = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3".freeze
  private_constant :BASE_URL

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
      summary: epic_hash.dig('fields', 'summary'),
      start_date: start_date(epic_hash)
    )
  end

  def issue(issue_hash)
    Issue.new(
      created_date: issue_hash.dig('fields', 'created'),
      epic_key: issue_hash.dig('fields', 'parent', 'key'),
      key: issue_hash['key'],
      labels: issue_hash.dig('fields', 'labels'),
      project_key: issue_hash.dig('fields', 'project', 'key'),
      status: issue_hash.dig('fields', 'status', 'name'),
      status_change_date: issue_hash.dig('fields', 'statuscategorychangedate'),
      points: points(issue_hash),
      summary: issue_hash.dig('fields', 'summary')
    )
  end

  def points(issue_hash)
    points_field_codes = (['customfield_10016'] + ENV.fetch('JIRA_STORY_POINTS_FIELD_CODES', '').split(',')).uniq
    points_field_codes.each do |field_code|
      value = issue_hash.dig('fields', field_code)
      next if value.blank?

      return value
    end
    nil
  end

  def start_date(epic_hash)
    start_date_field_codes = (['customfield_10015'] + ENV.fetch('JIRA_START_DATE_FIELD_CODES', '').split(',')).uniq
    start_date_field_codes.each do |field_code|
      value = epic_hash.dig('fields', field_code)
      next if value.blank?

      return value
    end
    nil
  end

  def query_epics_page(jql_string, start_at, epics)
    request_query_params = { query: { jql: jql_string, startAt: start_at, maxResults: 100 } }

    response = HTTParty.get("#{BASE_URL}/search", request_params.merge(request_query_params))
    json_response = JSON.parse(response.body)

    total = json_response['total']
    epics += json_response['issues'].map { |epic_hash| epic(epic_hash) }

    start_at += json_response['maxResults']

    [start_at, total, epics]
  end

  def query_issues_page(jql_string, start_at, issues)
    request_query_params = { query: { jql: jql_string, startAt: start_at, maxResults: 100 } }

    response = HTTParty.get("#{BASE_URL}/search", request_params.merge(request_query_params))
    json_response = JSON.parse(response.body)

    total = json_response['total']
    issues += json_response['issues'].map { |issue_hash| issue(issue_hash) }

    start_at += json_response['maxResults']

    [start_at, total, issues]
  end
end
