# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EstimatedFinishDateCalculator do
  describe '#weeks_lower_value' do
    subject do
      described_class.new(
        remaining_story_points: remaining_story_points,
        avg_story_points_per_week: avg_story_points_per_week,
        uncertainty_percentage: uncertainty_percentage
      ).weeks_lower_value
    end

    let(:uncertainty_percentage) { 50 }

    context 'when remaining_story_points is 0' do
      let(:remaining_story_points) { 0 }
      let(:avg_story_points_per_week) { 10 }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when avg_story_points_per_week is 0' do
      let(:remaining_story_points) { 35 }
      let(:avg_story_points_per_week) { 0 }

      it 'returns infinit' do
        expect(subject).to eq(Float::INFINITY)
      end
    end

    context 'when remaining_story_points and avg_story_points_per_week are not 0' do
      let(:remaining_story_points) { 35 }
      let(:avg_story_points_per_week) { 10 }

      it 'returns the number of weeks to finish without considering uncertainty' do
        expect(subject).to eq(3.5)
      end
    end
  end

  describe '#date_lower_value' do
    subject do
      described_class.new(
        remaining_story_points: remaining_story_points,
        avg_story_points_per_week: avg_story_points_per_week,
        uncertainty_percentage: uncertainty_percentage
      ).date_lower_value
    end

    let(:uncertainty_percentage) { 50 }
    let(:beginning_of_week) { Time.zone.today.beginning_of_week }

    context 'when remaining_story_points is 0' do
      let(:remaining_story_points) { 0 }
      let(:avg_story_points_per_week) { 10 }

      it 'returns beginning of current week' do
        expect(subject).to eq(beginning_of_week)
      end
    end

    context 'when remaining_story_points and avg_story_points_per_week are not 0' do
      let(:remaining_story_points) { 35 }
      let(:avg_story_points_per_week) { 10 }

      it 'returns the calculated week to finish without considering uncertainty' do
        expect(subject).to eq(beginning_of_week + 3.5.weeks)
      end
    end
  end

  describe '#weeks_higher_value' do
    subject do
      described_class.new(
        remaining_story_points: remaining_story_points,
        avg_story_points_per_week: avg_story_points_per_week,
        uncertainty_percentage: uncertainty_percentage
      ).weeks_higher_value
    end

    context 'when uncertainty_percentage is 0' do
      let(:uncertainty_percentage) { 0 }

      context 'when remaining_story_points is 0' do
        let(:remaining_story_points) { 0 }
        let(:avg_story_points_per_week) { 10 }

        it 'returns 0' do
          expect(subject).to eq(0)
        end
      end

      context 'when avg_story_points_per_week is 0' do
        let(:remaining_story_points) { 35 }
        let(:avg_story_points_per_week) { 0 }

        it 'returns infinit' do
          expect(subject).to eq(Float::INFINITY)
        end
      end

      context 'when remaining_story_points and avg_story_points_per_week are not 0' do
        let(:remaining_story_points) { 35 }
        let(:avg_story_points_per_week) { 10 }

        it 'returns the number of weeks to finish without considering uncertainty' do
          expect(subject).to eq(3.5)
        end
      end
    end

    context 'when uncertainty_percentage is not 0' do
      let(:uncertainty_percentage) { 50 }

      context 'when remaining_story_points is 0' do
        let(:remaining_story_points) { 0 }
        let(:avg_story_points_per_week) { 10 }

        it 'returns 0' do
          expect(subject).to eq(0)
        end
      end

      context 'when avg_story_points_per_week is 0' do
        let(:remaining_story_points) { 35 }
        let(:avg_story_points_per_week) { 0 }

        it 'returns infinit' do
          expect(subject).to eq(Float::INFINITY)
        end
      end

      context 'when remaining_story_points and avg_story_points_per_week are not 0' do
        let(:remaining_story_points) { 35 }
        let(:avg_story_points_per_week) { 10 }

        it 'returns the number of weeks to finish considering uncertainty' do
          expect(subject).to eq(5.3)
        end
      end
    end
  end

  describe '#date_higher_value' do
    subject do
      described_class.new(
        remaining_story_points: remaining_story_points,
        avg_story_points_per_week: avg_story_points_per_week,
        uncertainty_percentage: uncertainty_percentage
      ).date_higher_value
    end

    let(:beginning_of_week) { Time.zone.today.beginning_of_week }

    context 'when uncertainty_percentage is 0' do
      let(:uncertainty_percentage) { 0 }

      context 'when remaining_story_points is 0' do
        let(:remaining_story_points) { 0 }
        let(:avg_story_points_per_week) { 10 }

        it 'returns beginning of current week' do
          expect(subject).to eq(beginning_of_week)
        end
      end

      context 'when remaining_story_points and avg_story_points_per_week are not 0' do
        let(:remaining_story_points) { 35 }
        let(:avg_story_points_per_week) { 10 }

        it 'returns the calculated week to finish without considering uncertainty' do
          expect(subject).to eq(beginning_of_week + 3.5.weeks)
        end
      end
    end

    context 'when uncertainty_percentage is not 0' do
      let(:uncertainty_percentage) { 50 }

      context 'when remaining_story_points is 0' do
        let(:remaining_story_points) { 0 }
        let(:avg_story_points_per_week) { 10 }

        it 'returns beginning of current week' do
          expect(subject).to eq(beginning_of_week)
        end
      end

      context 'when remaining_story_points and avg_story_points_per_week are not 0' do
        let(:remaining_story_points) { 35 }
        let(:avg_story_points_per_week) { 10 }

        it 'returns the calculated week to finish considering uncertainty' do
          expect(subject).to eq(beginning_of_week + 5.3.weeks)
        end
      end
    end
  end
end
