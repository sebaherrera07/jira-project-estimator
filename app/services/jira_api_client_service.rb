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
    next_page_token = nil

    loop do
      next_page_token, is_last, epics = query_epics_page(jql_string, next_page_token, epics)
      break if is_last
    end

    epics
  end

  def query_project_epic(project_key, epic_key)
    body = { jql: "project = #{project_key} AND issuetype = Epic AND key = #{epic_key}", maxResults: 1,
             fields: epic_fields }
    response = HTTParty.post("#{BASE_URL}/search/jql", request_params.merge(body: body.to_json, headers: json_headers))
    json_response = JSON.parse(response.body)
    epic_hash = json_response['issues'].first
    epic(epic_hash)
  end

  def query_epic_issues(project_key, epic_key, labels = [])
    jql_string = "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic"
    jql_string += " AND labels in (#{labels.join(',')})" if labels.present?

    issues = []
    next_page_token = nil

    loop do
      next_page_token, is_last, issues = query_issues_page(jql_string, next_page_token, issues)
      break if is_last
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

  def json_headers
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
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

  def query_epics_page(jql_string, next_page_token, epics)
    body = { jql: jql_string, maxResults: 100, fields: epic_fields }
    body[:nextPageToken] = next_page_token if next_page_token

    response = HTTParty.post("#{BASE_URL}/search/jql", request_params.merge(body: body.to_json, headers: json_headers))
    json_response = JSON.parse(response.body)

    is_last = json_response['isLast']
    epics += json_response['issues'].map { |epic_hash| epic(epic_hash) }
    next_token = json_response['nextPageToken']

    [next_token, is_last, epics]
  end

  def query_issues_page(jql_string, next_page_token, issues)
    body = { jql: jql_string, maxResults: 100, fields: issue_fields }
    body[:nextPageToken] = next_page_token if next_page_token

    response = HTTParty.post("#{BASE_URL}/search/jql", request_params.merge(body: body.to_json, headers: json_headers))
    json_response = JSON.parse(response.body)

    is_last = json_response['isLast']
    issues += json_response['issues'].map { |issue_hash| issue(issue_hash) }
    next_token = json_response['nextPageToken']

    [next_token, is_last, issues]
  end
end
