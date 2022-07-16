# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JiraApiClientService do
  describe '#query_projects' do
    subject { described_class.new.query_projects }

    let(:url) { "#{ENV.fetch('JIRA_SITE_URL')}rest/api/3/project/search" }
    let(:request_params) do
      {
        headers: { 'Accept' => 'application/json' },
        basic_auth: {
          username: ENV.fetch('JIRA_USERNAME'),
          password: ENV.fetch('JIRA_API_TOKEN')
        }
      }
    end

    it 'makes request with expected options' do
      expect(HTTParty).to receive(:get).with(url, request_params).and_return(true)
      subject
    end
  end
end
