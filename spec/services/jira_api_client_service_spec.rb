# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JiraApiClientService do
  describe '#jira_client' do
    subject { described_class.new.jira_client }

    let(:jira_options) do
      {
        username: ENV.fetch('JIRA_USERNAME'),
        site: ENV.fetch('JIRA_SITE_URL'),
        context_path: '',
        auth_type: :basic,
        default_headers: { 'Authorization' => "Bearer #{ENV.fetch('JIRA_API_TOKEN')}" }
      }
    end

    it 'calls JIRA::Client with expected options' do
      expect(JIRA::Client).to receive(:new).with(jira_options).and_return(true)
      subject
    end
  end
end
