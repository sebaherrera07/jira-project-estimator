# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicEstimationPresenter do
  let(:issues) { build_list(:issue, 3) }
  let(:remaining_story_points) { 50 }
  let(:implementation_start_date) { 3.weeks.ago.to_date }

  describe '#avg_story_points_per_week_since_beginning' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date
      ).avg_story_points_per_week_since_beginning
    end

    before do
      allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(5.0)
    end

    it 'returns the average story points that the calculator returns' do
      expect(subject).to eq(5.0)
    end
  end

  describe '#avg_story_points_per_week_since_last_3_weeks' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date
      ).avg_story_points_per_week_since_last_3_weeks
    end

    before do
      allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(3.0)
    end

    it 'returns the average story points that the calculator returns' do
      expect(subject).to eq(3.0)
    end
  end

  describe '#estimated_weeks_to_complete_using_since_beggining_avg' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date
      ).estimated_weeks_to_complete_using_since_beggining_avg
    end

    context 'when the average is 0' do
      before do
        allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(0)
      end

      it 'returns message about estimation not possible' do
        expect(subject).to eq("Avg is 0. Can't generate estimation.")
      end
    end

    context 'when the average is not 0' do
      before do
        allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(10)
      end

      it 'returns estimation message' do
        weeks = (remaining_story_points / 10.to_f).round(1)
        date = Time.zone.today.beginning_of_week + weeks.weeks
        expect(subject).to eq("#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})")
      end
    end
  end

  describe '#estimated_weeks_to_complete_using_since_last_3_weeks_avg' do
    subject do
      described_class.new(
        issues: issues,
        remaining_story_points: remaining_story_points,
        implementation_start_date: implementation_start_date
      ).estimated_weeks_to_complete_using_since_last_3_weeks_avg
    end

    context 'when the average is 0' do
      before do
        allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(0)
      end

      it 'returns message about estimation not possible' do
        expect(subject).to eq("Avg is 0. Can't generate estimation.")
      end
    end

    context 'when the average is not 0' do
      before do
        allow_any_instance_of(AverageStoryPointsCalculator).to receive(:calculate).and_return(10)
      end

      it 'returns estimation message' do
        weeks = (remaining_story_points / 10.to_f).round(1)
        date = Time.zone.today.beginning_of_week + weeks.weeks
        expect(subject).to eq("#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})")
      end
    end
  end
end
