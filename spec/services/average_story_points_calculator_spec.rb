# frozen_string_literal: true

require 'rails_helper'

# TODO: fix intermittent failures
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
      let(:implementation_start_date) { 5.weeks.ago.beginning_of_week.to_date }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when there are completed issues but are all unestimated' do
      let(:completed_issues) { build_list(:issue, rand(1..2), :done, :unestimated) }
      let(:weeks_ago_since) { 0 }
      let(:implementation_start_date) { 5.weeks.ago.beginning_of_week.to_date }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when there are completed issues' do
      let(:issue1) { build(:issue, :done, story_points: 1, status_change_date: 5.weeks.ago) }
      let(:issue2) { build(:issue, :done, story_points: 2, status_change_date: 4.weeks.ago) }
      let(:issue3) { build(:issue, :done, story_points: 3, status_change_date: 3.weeks.ago) }
      let(:issue4) { build(:issue, :done, story_points: nil, status_change_date: 2.weeks.ago) }
      let(:issue5) { build(:issue, :done, story_points: 8, status_change_date: 1.week.ago) }
      let(:issue6) { build(:issue, :done, story_points: 13, status_change_date: Time.zone.now) }
      let(:completed_issues) { [issue1, issue2, issue3, issue4, issue5, issue6] }
      let(:implementation_start_date) { 5.weeks.ago.beginning_of_week.to_date }

      context 'when calculating average since beginning' do
        let(:weeks_ago_since) { 0 }

        it 'returns the average of expected issues' do
          story_points_sum = issue1.story_points + issue2.story_points + issue3.story_points + issue5.story_points
          weeks_in_period = 5
          expect(subject).to eq((story_points_sum / weeks_in_period.to_f).round(1))
        end

        it 'returns the average number' do
          expect(subject).to eq(2.8)
        end
      end

      context 'when calculating average since 3 weeks ago' do
        let(:weeks_ago_since) { 3 }

        it 'returns the average of expected issues' do
          story_points_sum = issue3.story_points + issue5.story_points
          weeks_in_period = 3
          expect(subject).to eq((story_points_sum / weeks_in_period.to_f).round(1))
        end

        it 'returns the average number' do
          expect(subject).to eq(3.7)
        end
      end

      context 'when calculating weeks ago param is earlier than implementation start' do
        let(:weeks_ago_since) { 8 }

        it 'returns the average of expected issues' do
          story_points_sum = issue1.story_points + issue2.story_points + issue3.story_points + issue5.story_points
          weeks_in_period = 5
          expect(subject).to eq((story_points_sum / weeks_in_period.to_f).round(1))
        end

        it 'returns the average number' do
          expect(subject).to eq(2.8)
        end
      end
    end
  end
end
