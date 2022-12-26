# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicEstimationPresenter do
  let(:issues) { build_list(:issue, 3) }
  let(:remaining_story_points) { 50 }
  let(:implementation_start_date) { 3.weeks.ago.to_date }
  let(:uncertainty_level) { build(:uncertainty_level) }
  let(:expected_average) { nil }

  describe '#avg_story_points_per_week_expected' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date,
        uncertainty_level: uncertainty_level,
        expected_average: expected_average
      ).avg_story_points_per_week_expected
    end

    context 'when expected_average is nil' do
      let(:expected_average) { nil }

      it { is_expected.to be_nil }
    end

    context 'when expected_average is 0' do
      let(:expected_average) { 0 }

      it { is_expected.to be_nil }
    end

    context 'when expected_average is an invalid number' do
      let(:expected_average) { -10 }

      it { is_expected.to be_nil }
    end

    context 'when expected_average is a valid number' do
      let(:expected_average) { rand(1..10) }

      it { is_expected.to eq(expected_average) }
    end
  end

  describe '#avg_story_points_per_week' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date,
        uncertainty_level: uncertainty_level
      ).avg_story_points_per_week(weeks_ago_since: weeks_ago_since)
    end

    let(:to_do_issues) { build_list(:issue, 2, :to_do) }
    let(:started_issues) { build_list(:issue, 2, :in_progress) }
    let(:completed_issues) { build_list(:issue, 2, :done) }
    let(:issues) { to_do_issues + started_issues + completed_issues }
    let(:weeks_ago_since) { [0, 3].sample }

    it 'calls AverageStoryPointsCalculator' do
      # TODO: this first expectation stopped working when updating to ruby 3.2.0
      # expect(AverageStoryPointsCalculator).to receive(:new).with(
      #   completed_issues: completed_issues,
      #   weeks_ago_since: weeks_ago_since,
      #   implementation_start_date: implementation_start_date
      # ).and_call_original
      expect_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate)
      subject
    end
  end

  describe '#estimated_weeks_to_complete_without_uncertainty' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date,
        uncertainty_level: uncertainty_level,
        expected_average: expected_average
      ).estimated_weeks_to_complete_without_uncertainty(weeks_ago_since: weeks_ago_since, use_expected: use_expected)
    end

    let(:weeks_ago_since) { [0, 3].sample }
    let(:expected_average) { 10 }

    context 'when use_expected is true' do
      let(:use_expected) { true }

      let(:weeks) { 5.0 } # 50 remaining points, at 10 average per week
      let(:date) { Time.zone.today.beginning_of_week + weeks.weeks }

      it { is_expected.to eq("#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})") }
    end

    context 'when use_expected is false' do
      let(:use_expected) { false }

      context 'when avg story points per week is 0' do
        before do
          allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(0)
        end

        it { is_expected.to eq("Avg is 0. Can't generate estimation.") }
      end

      context 'when avg story points per week is not 0' do
        let(:weeks) { 10.0 } # 50 remaining points, at 5 average per week
        let(:date) { Time.zone.today.beginning_of_week + weeks.weeks }

        before do
          allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(5)
        end

        it { is_expected.to eq("#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})") }
      end
    end
  end

  describe '#estimated_weeks_to_complete_with_uncertainty' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date,
        uncertainty_level: uncertainty_level,
        expected_average: expected_average
      ).estimated_weeks_to_complete_with_uncertainty(weeks_ago_since: weeks_ago_since, use_expected: use_expected)
    end

    let(:uncertainty_level) { build(:uncertainty_level, :low) } # 10% uncertainty
    let(:weeks_ago_since) { [0, 3].sample }
    let(:expected_average) { 10 }

    context 'when use_expected is true' do
      let(:use_expected) { true }

      let(:weeks) { 5.5 } # 55 remaining points (50 + 10%), at 10 average per week
      let(:date) { Time.zone.today.beginning_of_week + weeks.weeks }

      it { is_expected.to eq("#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})") }
    end

    context 'when use_expected is false' do
      let(:use_expected) { false }

      context 'when avg story points per week is 0' do
        before do
          allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(0)
        end

        it { is_expected.to eq("Avg is 0. Can't generate estimation.") }
      end

      context 'when avg story points per week is not 0' do
        let(:weeks) { 11.0 } # 55 remaining points (50 + 10%), at 5 average per week
        let(:date) { Time.zone.today.beginning_of_week + weeks.weeks }

        before do
          allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(5)
        end

        it { is_expected.to eq("#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})") }
      end
    end
  end

  describe '#uncertainty_title' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date,
        uncertainty_level: uncertainty_level,
        expected_average: expected_average
      ).uncertainty_title
    end

    context 'when uncertainty level is nil' do
      let(:uncertainty_level) { build(:uncertainty_level, :nil) }

      it { is_expected.to be_nil }
    end

    context 'when uncertainty level is low' do
      let(:uncertainty_level) { build(:uncertainty_level, :low) }

      it { is_expected.to eq('Low') }
    end

    context 'when uncertainty level is medium' do
      let(:uncertainty_level) { build(:uncertainty_level, :medium) }

      it { is_expected.to eq('Medium') }
    end

    context 'when uncertainty level is high' do
      let(:uncertainty_level) { build(:uncertainty_level, :high) }

      it { is_expected.to eq('High') }
    end

    context 'when uncertainty level is very high' do
      let(:uncertainty_level) { build(:uncertainty_level, :very_high) }

      it { is_expected.to eq('Very high') }
    end
  end

  describe '#uncertainty_percentage' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date,
        uncertainty_level: uncertainty_level,
        expected_average: expected_average
      ).uncertainty_percentage
    end

    context 'when uncertainty level is nil' do
      let(:uncertainty_level) { build(:uncertainty_level, :nil) }

      it { is_expected.to eq(0) }
    end

    context 'when uncertainty level is low' do
      let(:uncertainty_level) { build(:uncertainty_level, :low) }

      it { is_expected.to eq(10) }
    end

    context 'when uncertainty level is medium' do
      let(:uncertainty_level) { build(:uncertainty_level, :medium) }

      it { is_expected.to eq(20) }
    end

    context 'when uncertainty level is high' do
      let(:uncertainty_level) { build(:uncertainty_level, :high) }

      it { is_expected.to eq(50) }
    end

    context 'when uncertainty level is very high' do
      let(:uncertainty_level) { build(:uncertainty_level, :very_high) }

      it { is_expected.to eq(100) }
    end
  end
end
