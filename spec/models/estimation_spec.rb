# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Estimation do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:epic_id) }
    it { is_expected.to validate_presence_of(:total_points) }
    it { is_expected.to validate_presence_of(:last_completed_week_number) }
    it { is_expected.to validate_presence_of(:remaining_weeks) }
    it { is_expected.to validate_presence_of(:estimated_finish_date) }
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
  end
end
