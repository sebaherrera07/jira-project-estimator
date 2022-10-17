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

    before do
      JiraApiMocker.new.stub_query_project_epics(project_key)
    end

    it 'returns a list of Epic objects' do
      expect(subject).to all(be_a(Epic))
    end

    it 'makes request with expected options' do
      subject
      url = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3/search"
      expect(WebMock).to have_requested(:get, url).with(
        headers: { 'Accept' => 'application/json' },
        basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')],
        query: {
          jql: "project = #{project_key} AND issuetype = Epic"
        }
      )
    end
  end

  describe '#query_project_epic' do
    subject { described_class.new.query_project_epic(project_key, epic_key) }

    let(:project_key) { 'TEST' }
    let(:epic_key) { 'TEST-5' }

    before do
      JiraApiMocker.new.stub_query_project_epic(project_key, epic_key)
    end

    it 'returns one Epic object' do
      expect(subject).to be_a(Epic)
    end

    it 'makes request with expected options' do
      subject
      url = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3/search"
      expect(WebMock).to have_requested(:get, url).with(
        headers: { 'Accept' => 'application/json' },
        basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')],
        query: {
          jql: "project = #{project_key} AND issuetype = Epic AND key = #{epic_key}"
        }
      )
    end
  end

  describe '#query_epic_issues' do
    subject { described_class.new.query_epic_issues(project_key, epic_key, labels) }

    let(:project_key) { 'TEST' }
    let(:epic_key) { 'TEST-5' }

    context 'when no labels are passed' do
      let(:labels) { nil }

      before do
        JiraApiMocker.new.stub_query_epic_issues(project_key, epic_key)
      end

      it 'returns a list of Issue objects' do
        expect(subject).to all(be_a(Issue))
      end

      it 'assigns story points to each Issue by default field' do
        expect(subject.map(&:story_points)).to eq([3.0, nil])
      end

      it 'makes request with expected options' do
        subject
        url = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3/search"
        expect(WebMock).to have_requested(:get, url).with(
          headers: { 'Accept' => 'application/json' },
          basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')],
          query: {
            jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic"
          }
        )
      end
    end

    context 'when labels are passed' do
      let(:labels) { ['label-1', 'label 2'] }

      before do
        JiraApiMocker.new.stub_query_epic_issues_with_labels(project_key, epic_key, labels)
      end

      it 'returns a list of Issue objects' do
        expect(subject).to all(be_a(Issue))
      end

      it 'makes request with expected options' do
        subject
        url = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3/search"
        expect(WebMock).to have_requested(:get, url).with(
          headers: { 'Accept' => 'application/json' },
          basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')],
          query: {
            jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) " \
                 "AND issuetype != Epic AND labels in (#{labels.join(',')})"
          }
        )
      end
    end

    context 'when story points custom field is different than default' do
      let(:labels) { nil }

      before do
        JiraApiMocker.new.stub_query_epic_issues_with_custom_story_points_field(project_key, epic_key)
      end

      it 'returns a list of Issue objects' do
        expect(subject).to all(be_a(Issue))
      end

      it 'assigns story points to each Issue by custom field' do
        expect(subject.map(&:story_points)).to eq([3.0, 2.0])
      end

      it 'makes request with expected options' do
        subject
        url = "#{ENV.fetch('JIRA_SITE_URL')}/rest/api/3/search"
        expect(WebMock).to have_requested(:get, url).with(
          headers: { 'Accept' => 'application/json' },
          basic_auth: [ENV.fetch('JIRA_USERNAME'), ENV.fetch('JIRA_API_TOKEN')],
          query: {
            jql: "project = #{project_key} AND (parent = #{epic_key} OR parentepic = #{epic_key}) AND issuetype != Epic"
          }
        )
      end
    end
  end
end
