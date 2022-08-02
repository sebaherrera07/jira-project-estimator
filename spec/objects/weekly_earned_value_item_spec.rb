# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeeklyEarnedValueItem do
  let(:weekly_earned_value_item) { build(:weekly_earned_value_item) }

  describe '#cumulative_earned_value' do
    subject { weekly_earned_value_item.cumulative_earned_value }

    context 'when previous cumulative earned value is 0' do
      context 'when earned value items is empty' do
        let(:weekly_earned_value_item) do
          build(:weekly_earned_value_item, earned_value_items: [], previous_cumulative_earned_value: 0)
        end

        it { is_expected.to eq(0) }
      end

      context 'when earned value items are present' do
        let(:earned_value_items) { build_list(:earned_value_item, 2) }
        let(:weekly_earned_value_item) do
          build(:weekly_earned_value_item, earned_value_items: earned_value_items, previous_cumulative_earned_value: 0)
        end

        it { is_expected.to eq(earned_value_items.sum(&:earned_value).round(2)) }
        it { is_expected.not_to eq(0) }
      end
    end

    context 'when previous cumulative earned value is not 0' do
      context 'when earned value items is empty' do
        let(:weekly_earned_value_item) do
          build(:weekly_earned_value_item, earned_value_items: [], previous_cumulative_earned_value: 10)
        end

        it { is_expected.to eq(10) }
      end

      context 'when earned value items are present' do
        let(:earned_value_items) { build_list(:earned_value_item, 2) }
        let(:weekly_earned_value_item) do
          build(:weekly_earned_value_item, earned_value_items: earned_value_items, previous_cumulative_earned_value: 10)
        end

        it { is_expected.to eq((10 + earned_value_items.sum(&:earned_value)).round(2)) }
      end
    end
  end

  describe '#earned_value' do
    subject { weekly_earned_value_item.earned_value }

    context 'when earned value items is empty' do
      let(:weekly_earned_value_item) do
        build(:weekly_earned_value_item, earned_value_items: [])
      end

      it { is_expected.to eq(0) }
    end

    context 'when earned value items are present' do
      let(:earned_value_items) { build_list(:earned_value_item, 2) }
      let(:weekly_earned_value_item) do
        build(:weekly_earned_value_item, earned_value_items: earned_value_items)
      end

      it { is_expected.to eq(earned_value_items.sum(&:earned_value).round(2)) }
    end
  end

  describe '#story_points_completed' do
    subject { weekly_earned_value_item.story_points_completed }

    context 'when earned value items is empty' do
      let(:weekly_earned_value_item) do
        build(:weekly_earned_value_item, earned_value_items: [])
      end

      it { is_expected.to eq(0) }
    end

    context 'when earned value items are present' do
      let(:earned_value_items) { build_list(:earned_value_item, 2) }
      let(:weekly_earned_value_item) do
        build(:weekly_earned_value_item, earned_value_items: earned_value_items)
      end

      it { is_expected.to eq(earned_value_items.sum(&:story_points)) }
    end
  end

  describe '#week_dates' do
    subject { weekly_earned_value_item.week_dates }

    let(:week) { build(:week, start_date: Date.new(2022, 7, 20)) }
    let(:weekly_earned_value_item) { build(:weekly_earned_value_item, week: week) }

    it { is_expected.to eq('2022-07-18 - 2022-07-24') }
  end

  describe '#week_number' do
    subject { weekly_earned_value_item.week_number }

    let(:week) { build(:week, number: [1, 2, 3, 4].sample) }
    let(:weekly_earned_value_item) { build(:weekly_earned_value_item, week: week) }

    it { is_expected.to eq(week.number) }
  end
end
