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

  describe '#issues_sorted' do
    subject { described_class.new(epic: epic, issues: issues).issues_sorted }

    let(:epic) { build(:epic) }
    let(:issues) { [issue_done1, issue_done2, issue_to_do, issue_in_progress] }

    let(:issue_done1) { build(:issue, :done, status_change_date: 2.days.ago) }
    let(:issue_done2) { build(:issue, :done, status_change_date: 5.days.ago) }
    let(:issue_to_do) { build(:issue, :to_do) }
    let(:issue_in_progress) { build(:issue, :in_progress) }

    it 'sorts issues by in progress, then pending, and then by completion date' do
      expect(subject).to eq([issue_in_progress, issue_to_do, issue_done2, issue_done1])
    end
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
        issues: issues
      ).progress_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to be_a(EpicProgressPresenter) }
  end

  describe '#estimation_presenter' do
    subject do
      described_class.new(
        epic: epic,
        issues: issues,
        uncertainty_level: uncertainty_level,
        expected_average: expected_average
      ).estimation_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }
    let(:uncertainty_level) { [nil, 'low', 'medium', 'high', 'very_high'].sample }
    let(:expected_average) { [nil, 5].sample }

    it { is_expected.to be_a(EpicEstimationPresenter) }
  end

  describe '#estimation_history_presenter' do
    subject do
      described_class.new(
        epic: epic,
        issues: issues,
        uncertainty_level: uncertainty_level,
        expected_average: expected_average
      ).estimation_history_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }
    let(:uncertainty_level) { [nil, 'low', 'medium', 'high', 'very_high'].sample }
    let(:expected_average) { [nil, 5].sample }

    it { is_expected.to be_a(EpicEstimationHistoryPresenter) }
  end

  describe '#earned_value_presenter' do
    subject do
      described_class.new(
        epic: epic,
        issues: issues
      ).earned_value_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to be_a(EpicEarnedValuePresenter) }
  end

  describe '#weekly_earned_value_presenter' do
    subject do
      described_class.new(
        epic: epic,
        issues: issues
      ).weekly_earned_value_presenter
    end

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to be_a(EpicWeeklyEarnedValuePresenter) }
  end
end
