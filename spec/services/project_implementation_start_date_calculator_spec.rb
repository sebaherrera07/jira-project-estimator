# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectImplementationStartDateCalculator do
  describe '#calculate' do
    subject { described_class.new(issues: issues).calculate }

    context 'when there are no issues' do
      let(:issues) { [] }

      it { is_expected.to be_nil }
    end

    context 'when there are no issues with status_change_date' do
      let(:issues) { build_list(:issue, 2, status_change_date: nil) }

      it { is_expected.to be_nil }
    end

    context 'when there are multiple issues with status_change_date' do
      let(:issue1) { build(:issue, status_change_date: 2.weeks.ago) }
      let(:issue2) { build(:issue, status_change_date: 3.weeks.ago) }
      let(:issue3) { build(:issue, status_change_date: 1.week.ago) }
      let(:issues) { [issue1, issue2, issue3] }

      it { is_expected.to eq(3.weeks.ago.to_date) }
    end
  end
end
