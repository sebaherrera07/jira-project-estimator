# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicPresenter do
  describe 'delegates to Epic' do
    subject { described_class.new(epic: epic, issues: issues) }

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to delegate_method(:key).to(:epic) }
    it { is_expected.to delegate_method(:labels).to(:epic) }
    it { is_expected.to delegate_method(:project_key).to(:epic) }
    it { is_expected.to delegate_method(:summary).to(:epic) }
  end

  describe '#issues_count_presenter' do
    subject { described_class.new(epic: epic, issues: issues).issues_count_presenter }

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to be_a(EpicIssuesCountPresenter) }
  end

  describe '#progress_presenter' do
    subject do
      described_class.new(
        epic: epic,
        issues: issues,
        implementation_start_date: implementation_start_date
      ).progress_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }
    let(:implementation_start_date) { [3.weeks.ago.to_date, nil].sample }

    it { is_expected.to be_a(EpicProgressPresenter) }
  end

  describe '#estimation_presenter' do
    subject do
      described_class.new(
        epic: epic,
        issues: issues,
        implementation_start_date: implementation_start_date
      ).estimation_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }
    let(:implementation_start_date) { [3.weeks.ago.to_date, nil].sample }

    it { is_expected.to be_a(EpicEstimationPresenter) }
  end

  describe '#earned_value_presenter' do
    subject do
      described_class.new(
        epic: epic,
        issues: issues,
        implementation_start_date: implementation_start_date
      ).earned_value_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }
    let(:implementation_start_date) { [3.weeks.ago.to_date, nil].sample }

    it { is_expected.to be_a(EpicEarnedValuePresenter) }
  end

  describe '#weekly_earned_value_presenter' do
    subject do
      described_class.new(
        epic: epic,
        issues: issues,
        implementation_start_date: implementation_start_date
      ).weekly_earned_value_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }
    let(:implementation_start_date) { [3.weeks.ago.to_date, nil].sample }

    it { is_expected.to be_a(EpicWeeklyEarnedValuePresenter) }
  end
end
