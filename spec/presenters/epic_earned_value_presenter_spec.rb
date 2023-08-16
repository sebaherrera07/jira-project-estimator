# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicEarnedValuePresenter do
  describe '#earned_value_items' do
    subject do
      described_class.new(
        completed_issues: completed_issues,
        total_points: total_points,
        implementation_start_date: implementation_start_date
      ).earned_value_items
    end

    context 'when epic has no completed issues' do
      let(:completed_issues) { [] }
      let(:total_points) { 50 }
      let(:implementation_start_date) { 5.weeks.ago.beginning_of_week.to_date }

      it 'returns empty array' do
        expect(subject).to eq([])
      end
    end

    context 'when epic has completed issues' do
      let(:completed_issues) { build_list(:issue, 2, :done, points: 10) }
      let(:implementation_start_date) { 5.weeks.ago.beginning_of_week.to_date }

      context 'when total points is 0' do
        let(:total_points) { 0 }

        it 'returns an array of EarnedValueItem' do
          expect(subject).to all(be_a(EarnedValueItem))
        end

        it 'assigns cumulative earned value to each item' do
          expect(subject.map(&:cumulative_earned_value)).to eq([0, 0])
        end
      end

      context 'when total points is not 0' do
        let(:total_points) { 100 }

        it 'returns an array of EarnedValueItem' do
          expect(subject).to all(be_a(EarnedValueItem))
        end

        it 'assigns cumulative earned value to each item' do
          expect(subject.map(&:cumulative_earned_value)).to eq([10, 20])
        end
      end
    end
  end
end
