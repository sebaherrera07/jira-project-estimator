# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JiraApiClientService do
  describe '#query_projects' do
    subject { described_class.new.query_projects }

    before do
      JiraApiMocker.new.stub_query_projects
    end

    it 'returns a list of Project objects' do
      expect(subject).to all(be_a(Project))
    end

    it 'makes request with expected options' do
      subject
      url = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3/project/search"
      expect(WebMock).to have_requested(:get, url).with(
        headers: { 'Accept' => 'application/json' },
        basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')]
      )
    end
  end

  describe '#query_project_epics' do
    subject { described_class.new.query_project_epics(project_key) }

    let(:project_key) { 'TEST' }
    let(:url) { "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3/search" }
    let(:request_params) do
      {
        headers: { 'Accept' => 'application/json' },
        basic_auth: {
          username: ENV.fetch('JIRA_USERNAME'),
          password: ENV.fetch('JIRA_API_TOKEN')
        },
        query: {
          jql: "project = #{project_key} AND issuetype = Epic"
        }
      }
    end

    it 'makes request with expected options' do
      expect(HTTParty).to receive(:get).with(url, request_params).and_return({ 'issues' => [] })
      subject
    end
  end

  describe '#query_epic_issues' do
    subject { described_class.new.query_epic_issues(project_key, epic_key) }

    let(:project_key) { 'TEST' }
    let(:epic_key) { 'TEST-5' }
    let(:url) { "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3/search" }
    let(:request_params) do
      {
        headers: { 'Accept' => 'application/json' },
        basic_auth: {
          username: ENV.fetch('JIRA_USERNAME'),
          password: ENV.fetch('JIRA_API_TOKEN')
        },
        query: {
          jql: "project = #{project_key} AND parent = #{epic_key}"
        }
      }
    end

    it 'makes request with expected options' do
      expect(HTTParty).to receive(:get).with(url, request_params).and_return({ 'issues' => [] })
      subject
    end
  end
end
