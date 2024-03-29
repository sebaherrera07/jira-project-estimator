# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Estimation do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:epic_id) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:total_points) }
    it { is_expected.to validate_presence_of(:last_completed_week_number) }
    it { is_expected.to validate_presence_of(:project_id) }
    it { is_expected.to validate_presence_of(:remaining_weeks) }
    it { is_expected.to validate_presence_of(:avg_weekly_earned_value) }
    it { is_expected.to validate_presence_of(:remaining_earned_value) }

    it {
      expect(subject).to validate_numericality_of(
        :last_completed_week_number
      ).is_greater_than_or_equal_to(0).only_integer
    }

    it { is_expected.to validate_numericality_of(:total_points).is_greater_than_or_equal_to(0).only_integer }
    it { is_expected.to validate_numericality_of(:remaining_weeks).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:avg_weekly_earned_value).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:remaining_earned_value).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:remaining_earned_value).is_less_than_or_equal_to(100) }

    it {
      expect(subject).to validate_numericality_of(
        :remaining_weeks_with_uncertainty
      ).is_greater_than_or_equal_to(0).allow_nil
    }

    it { is_expected.to validate_numericality_of(:uncertainty_percentage).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe '#estimated_finish_date' do
    subject { estimation.estimated_finish_date }

    let!(:estimation) { create(:estimation, created_at: '2022-10-18', remaining_weeks: 4) }

    it { is_expected.to eq(Date.new(2022, 11, 14)) }
  end

  describe '#estimated_finish_date_with_uncertainty' do
    subject { estimation.estimated_finish_date_with_uncertainty }

    let!(:estimation) do
      create(:estimation, created_at: '2022-10-18', uncertainty_level: UncertaintyLevel::LEVELS.keys.sample,
                          remaining_weeks_with_uncertainty: 6)
    end

    it { is_expected.to eq(Date.new(2022, 11, 28)) }
  end

  describe '#label' do
    subject { estimation.label }

    context 'when filters_applied is nil' do
      let(:estimation) { create(:estimation, filters_applied: nil) }

      it { is_expected.to be_nil }
    end

    context 'when filters_applied has other attributes' do
      let(:estimation) { create(:estimation, filters_applied: { 'uncertainty_level' => 'low' }) }

      it { is_expected.to be_nil }
    end

    context 'when filters_applied has labels' do
      let(:estimation) { create(:estimation, filters_applied: { 'labels' => 'v1' }) }

      it { is_expected.to eq('v1') }
    end
  end
end
