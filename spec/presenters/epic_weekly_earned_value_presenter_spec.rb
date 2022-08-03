# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicWeeklyEarnedValuePresenter do
  describe '#weekly_earned_value_items' do
    subject do
      described_class.new(
        earned_value_items: earned_value_items,
        implementation_start_date: implementation_start_date
      ).weekly_earned_value_items
    end

    context 'when there are no earned value items' do
      let(:earned_value_items) { [] }
      let(:implementation_start_date) { 3.weeks.ago.beginning_of_week.to_date }

      it 'returns empty array' do
        expect(subject).to eq([])
      end
    end

    context 'when there are earned value items' do
      let(:implementation_start_date) { 5.weeks.ago.beginning_of_week.to_date }
      let(:issue1) { build(:issue, :done, status_change_date: 5.weeks.ago.beginning_of_week + 1.day) }
      let(:issue2) { build(:issue, :done, status_change_date: 5.weeks.ago.beginning_of_week + 2.days) }
      let(:issue3) { build(:issue, :done, status_change_date: 3.weeks.ago.beginning_of_week + 1.day) }
      let(:issue4) { build(:issue, :done, status_change_date: 2.weeks.ago.beginning_of_week + 1.day) }
      let(:earned_value_item1) do
        build(:earned_value_item, completed_issue: issue1, implementation_start_date: implementation_start_date)
      end
      let(:earned_value_item2) do
        build(:earned_value_item, completed_issue: issue2, implementation_start_date: implementation_start_date)
      end
      let(:earned_value_item3) do
        build(:earned_value_item, completed_issue: issue3, implementation_start_date: implementation_start_date)
      end
      let(:earned_value_item4) do
        build(:earned_value_item, completed_issue: issue4, implementation_start_date: implementation_start_date)
      end
      let(:earned_value_items) { [earned_value_item1, earned_value_item2, earned_value_item3, earned_value_item4] }

      it 'returns one item per week of work until the last earned value item' do
        expect(subject.count).to eq(4)
      end

      it 'returns an array of WeeklyEarnedValueItem' do
        expect(subject).to all(be_a(WeeklyEarnedValueItem))
      end

      it 'assigns cumulative earned value to each item' do
        cumulative_earned_values = subject.map(&:cumulative_earned_value)
        expect(cumulative_earned_values.count).to eq(4)
        expect(cumulative_earned_values.first).to be <= cumulative_earned_values.second
        expect(cumulative_earned_values.second).to be <= cumulative_earned_values.third
        expect(cumulative_earned_values.third).to be <= cumulative_earned_values.fourth
      end

      it 'assigns week number to each item' do
        expect(subject.map(&:week_number)).to eq([1, 2, 3, 4])
      end
    end
  end
end
