# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicPresenter do
  describe 'delegates to Epic' do
    subject { described_class.new(epic, issues) }

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to delegate_method(:key).to(:epic) }
    it { is_expected.to delegate_method(:labels).to(:epic) }
    it { is_expected.to delegate_method(:project_key).to(:epic) }
    it { is_expected.to delegate_method(:summary).to(:epic) }
  end

  describe 'delegates to EpicIssuesCountPresenter' do
    subject { described_class.new(epic, issues) }

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to delegate_method(:total_issues_count).to(:issues_count_presenter) }
    it { is_expected.to delegate_method(:completed_issues_count).to(:issues_count_presenter) }
    it { is_expected.to delegate_method(:remaining_issues_count).to(:issues_count_presenter) }
    it { is_expected.to delegate_method(:started_issues_count).to(:issues_count_presenter) }
    it { is_expected.to delegate_method(:unestimated_issues_count).to(:issues_count_presenter) }
  end

  describe 'delegates to EpicProgressPresenter' do
    subject { described_class.new(epic, issues) }

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to delegate_method(:total_story_points).to(:progress_presenter) }
    it { is_expected.to delegate_method(:completed_story_points).to(:progress_presenter) }
    it { is_expected.to delegate_method(:remaining_story_points).to(:progress_presenter) }
    it { is_expected.to delegate_method(:earned_value).to(:progress_presenter) }
    it { is_expected.to delegate_method(:remaining_earned_value).to(:progress_presenter) }
    it { is_expected.to delegate_method(:any_unestimated_issues?).to(:progress_presenter) }
  end

  describe 'delegates to EpicEstimationPresenter' do
    subject { described_class.new(epic, issues) }

    let(:epic) { build(:epic) }
    let(:issues) { [] }

    it { is_expected.to delegate_method(:avg_story_points_per_week_since_beginning).to(:estimation_presenter) }
    it { is_expected.to delegate_method(:avg_story_points_per_week_since_last_3_weeks).to(:estimation_presenter) }

    it {
      expect(subject).to delegate_method(
        :estimated_weeks_to_complete_using_since_beggining_avg
      ).to(:estimation_presenter)
    }

    it {
      expect(subject).to delegate_method(
        :estimated_weeks_to_complete_using_since_last_3_weeks_avg
      ).to(:estimation_presenter)
    }
  end
end
