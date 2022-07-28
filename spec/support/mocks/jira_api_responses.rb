# frozen_string_literal: true

class JiraApiResponses
  def self.query_projects_response_body
    {
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
  end

  def self.query_project_epics_response_body(project_key)
    {
      'issues' => [
        {
          'key' => 'EPIC-1',
          'fields' => {
            'labels' => %w[label-1 label-2],
            'project' => {
              'key' => project_key
            },
            'summary' => 'Epic summary A'
          }
        },
        {
          'key' => 'EPIC-2',
          'fields' => {
            'labels' => [],
            'project' => {
              'key' => project_key
            },
            'summary' => 'Epic summary B'
          }
        }
      ]
    }.to_json
  end

  def self.query_project_epic_response_body(project_key, epic_key)
    {
      'issues' => [
        {
          'key' => epic_key,
          'fields' => {
            'labels' => %w[label-1 label-2],
            'project' => {
              'key' => project_key
            },
            'summary' => 'Epic summary A'
          }
        }
      ]
    }.to_json
  end

  def self.query_epic_issues_response_body(project_key, epic_key)
    {
      'issues' => [
        {
          'key' => 'ISSUE-1',
          'fields' => {
            'created' => '2020-01-01T00:00:00.000Z',
            'customfield_10016' => 3.0,
            'labels' => %w[label-1 label-2],
            'parent' => {
              'key' => epic_key
            },
            'project' => {
              'key' => project_key
            },
            'status' => {
              'name' => 'Done'
            },
            'statuscategorychangedate' => '2020-01-01T00:00:00.000Z',
            'summary' => 'Issue summary A'
          }
        },
        {
          'key' => 'ISSUE-2',
          'fields' => {
            'created' => '2020-01-01T00:00:00.000Z',
            'customfield_10016' => nil,
            'labels' => [],
            'parent' => {
              'key' => epic_key
            },
            'project' => {
              'key' => project_key
            },
            'status' => {
              'name' => 'In Progress'
            },
            'statuscategorychangedate' => '2020-01-01T00:00:00.000Z',
            'summary' => 'Issue summary B'
          }
        }
      ]
    }.to_json
  end

  def self.query_epic_issues_with_labels_response_body(project_key, epic_key, labels)
    {
      'issues' => [
        {
          'key' => 'ISSUE-1',
          'fields' => {
            'created' => '2020-01-01T00:00:00.000Z',
            'customfield_10016' => 3.0,
            'labels' => labels,
            'parent' => {
              'key' => epic_key
            },
            'project' => {
              'key' => project_key
            },
            'status' => {
              'name' => 'Done'
            },
            'statuscategorychangedate' => '2020-01-01T00:00:00.000Z',
            'summary' => 'Issue summary A'
          }
        },
        {
          'key' => 'ISSUE-2',
          'fields' => {
            'created' => '2020-01-01T00:00:00.000Z',
            'customfield_10016' => nil,
            'labels' => labels,
            'parent' => {
              'key' => epic_key
            },
            'project' => {
              'key' => project_key
            },
            'status' => {
              'name' => 'In Progress'
            },
            'statuscategorychangedate' => '2020-01-01T00:00:00.000Z',
            'summary' => 'Issue summary B'
          }
        }
      ]
    }.to_json
  end
end
