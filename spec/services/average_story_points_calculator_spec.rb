# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AverageStoryPointsCalculator do
  describe '#calculate' do
    subject do
      described_class.new(
        completed_issues: completed_issues,
        weeks_ago_since: weeks_ago_since,
        implementation_start_date: implementation_start_date
      ).calculate
    end

    context 'when there are no completed issues' do
      let(:completed_issues) { [] }
      let(:weeks_ago_since) { 0 }
      let(:implementation_start_date) { Time.zone.today.beginning_of_week - 5.weeks }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when there are completed issues but are all unestimated' do
      let(:completed_issues) { build_list(:issue, rand(1..2), :done, :unestimated) }
      let(:weeks_ago_since) { 0 }
      let(:implementation_start_date) { Time.zone.today.beginning_of_week - 5.weeks }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    # TODO: Add more tests for other scenarios
  end
end
