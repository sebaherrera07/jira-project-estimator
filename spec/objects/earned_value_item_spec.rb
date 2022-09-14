# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EarnedValueItem do
  let(:earned_value_item) { build(:earned_value_item) }

  describe '#cumulative_earned_value' do
    subject { earned_value_item.cumulative_earned_value }

    context 'when previous cumulative earned value is 0' do
      context 'when issue story points is nil' do
        let(:issue) { build(:issue, :done, :unestimated) }
        let(:earned_value_item) do
          build(:earned_value_item, completed_issue: issue, previous_cumulative_earned_value: 0)
        end

        it { is_expected.to eq(0) }
      end

      context 'when issue story points is 0' do
        let(:issue) { build(:issue, :done, story_points: 0) }
        let(:earned_value_item) do
          build(:earned_value_item, completed_issue: issue, previous_cumulative_earned_value: 0)
        end

        it { is_expected.to eq(0) }
      end

      context 'when issue story points is not 0' do
        let(:issue) { build(:issue, :done, story_points: 5) }
        let(:earned_value_item) do
          build(:earned_value_item, completed_issue: issue, total_story_points: 100,
                                    previous_cumulative_earned_value: 0)
        end

        it { is_expected.to eq(5) }
      end
    end

    context 'when previous cumulative earned value is not 0' do
      context 'when issue story points is nil' do
        let(:issue) { build(:issue, :done, :unestimated) }
        let(:earned_value_item) do
          build(:earned_value_item, completed_issue: issue, previous_cumulative_earned_value: 50)
        end

        it { is_expected.to eq(50) }
      end

      context 'when issue story points is 0' do
        let(:issue) { build(:issue, :done, story_points: 0) }
        let(:earned_value_item) do
          build(:earned_value_item, completed_issue: issue, previous_cumulative_earned_value: 60.55)
        end

        it { is_expected.to eq(60.55) }
      end

      context 'when issue story points is not 0' do
        let(:issue) { build(:issue, :done, story_points: 5) }
        let(:earned_value_item) do
          build(:earned_value_item, completed_issue: issue, total_story_points: 33,
                                    previous_cumulative_earned_value: 50)
        end

        it { is_expected.to eq(65.15) }
      end
    end
  end

  describe '#earned_value' do
    subject { earned_value_item.earned_value }

    let(:earned_value_item) { build(:earned_value_item, completed_issue: issue) }

    context 'when issue story points is nil' do
      let(:issue) { build(:issue, :done, :unestimated) }

      it { is_expected.to eq(0) }
    end

    context 'when issue story points is 0' do
      let(:issue) { build(:issue, :done, story_points: 0) }

      it { is_expected.to eq(0) }
    end

    context 'when issue story points is not 0' do
      let(:issue) { build(:issue, :done, story_points: 5) }
      let(:earned_value_item) do
        build(:earned_value_item, completed_issue: issue, total_story_points: 33)
      end

      it { is_expected.to eq(15.15) }
    end

    context 'when total story points is 0' do
      # This scenario shouldn't be possible but it's better to cover it.
      let(:issue) { build(:issue, :done, story_points: 5) }
      let(:earned_value_item) do
        build(:earned_value_item, completed_issue: issue, total_story_points: 0)
      end

      it { is_expected.to eq(0) }
    end
  end

  describe '#finish_date' do
    subject { earned_value_item.finish_date }

    let(:issue) { build(:issue, :done, status_change_date: Date.new(2020, 1, 1)) }
    let(:earned_value_item) { build(:earned_value_item, completed_issue: issue) }

    it { is_expected.to eq(Date.new(2020, 1, 1)) }
  end

  describe '#finish_week_dates' do
    subject { earned_value_item.finish_week_dates }

    let(:issue) { build(:issue, :done, status_change_date: Date.new(2022, 7, 20)) }
    let(:earned_value_item) { build(:earned_value_item, completed_issue: issue) }

    it { is_expected.to eq('2022-07-18 - 2022-07-24') }
  end

  describe '#finish_week_number' do
    subject { earned_value_item.finish_week_number }

    let(:issue) { build(:issue, :done, status_change_date: Date.new(2022, 7, 20)) }
    let(:earned_value_item) do
      build(:earned_value_item, completed_issue: issue, implementation_start_date: implementation_start_date)
    end

    context 'when finish date week is the same as implementation start date week' do
      let(:implementation_start_date) { Date.new(2022, 7, 20).beginning_of_week }

      it { is_expected.to eq(1) }
    end

    context 'when finish date week is after the implementation start date week' do
      let(:implementation_start_date) { (Date.new(2022, 7, 20) - 3.weeks).beginning_of_week }

      it { is_expected.to eq(4) }
    end
  end

  describe '#issue_key' do
    subject { earned_value_item.issue_key }

    let(:issue) { build(:issue, :done, key: 'ABC-123') }
    let(:earned_value_item) { build(:earned_value_item, completed_issue: issue) }

    it { is_expected.to eq('ABC-123') }
  end

  describe '#story_points' do
    subject { earned_value_item.story_points }

    let(:earned_value_item) { build(:earned_value_item, completed_issue: issue) }

    context 'when issue story points is nil' do
      let(:issue) { build(:issue, :done, :unestimated) }

      it { is_expected.to eq(0) }
    end

    context 'when issue story points is 0' do
      let(:issue) { build(:issue, :done, story_points: 0) }

      it { is_expected.to eq(0) }
    end

    context 'when issue story points is not 0' do
      let(:issue) { build(:issue, :done, story_points: 5) }

      it { is_expected.to eq(5) }
    end
  end
end
