# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PertPresenter do
  describe '#estimated_days_to_complete' do
    subject do
      described_class.new(
        story_points: story_points,
        optimistic: optimistic,
        most_likely: most_likely,
        pessimistic: pessimistic,
        start_date: start_date
      ).estimated_days_to_complete
    end

    let(:story_points) { 50 }
    let(:optimistic) { 1 }
    let(:most_likely) { 1.5 }
    let(:pessimistic) { 2.5 }
    let(:start_date) { nil }

    it 'uses the appropriate formula' do
      optimistic_number_of_days = 50 * 1 # 1 day per story point
      most_likely_number_of_days = 50 * 1.5 # 1.5 days per story point
      pessimistic_number_of_days = 50 * 2.5 # 2.5 days per story point
      expect(subject).to eq(
        ((optimistic_number_of_days + (4 * most_likely_number_of_days) + pessimistic_number_of_days) / 6).round
      )
    end

    it 'returns the expected rounded number' do
      expect(subject).to eq(79)
    end
  end

  describe '#estimated_finish_date' do
    subject do
      described_class.new(
        story_points: story_points,
        optimistic: optimistic,
        most_likely: most_likely,
        pessimistic: pessimistic,
        start_date: start_date
      ).estimated_finish_date
    end

    let(:story_points) { 50 }
    let(:optimistic) { 1 }
    let(:most_likely) { 1.5 }
    let(:pessimistic) { 2.5 }

    context 'when start_date is nil' do
      let(:start_date) { nil }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when start_date is present' do
      let(:start_date) { 2.weeks.from_now.to_date.beginning_of_week }

      it 'returns the estimated end date formatted' do
        expect(subject).to eq((start_date + 15.8.weeks).strftime('%a, %d %b %Y'))
      end
    end
  end

  describe '#estimated_weeks_to_complete' do
    subject do
      described_class.new(
        story_points: story_points,
        optimistic: optimistic,
        most_likely: most_likely,
        pessimistic: pessimistic,
        start_date: start_date
      ).estimated_weeks_to_complete
    end

    let(:story_points) { 50 }
    let(:optimistic) { 1 }
    let(:most_likely) { 1.5 }
    let(:pessimistic) { 2.5 }
    let(:start_date) { nil }

    it 'uses the appropriate formula' do
      optimistic_number_of_days = 50 * 1 # 1 day per story point
      most_likely_number_of_days = 50 * 1.5 # 1.5 days per story point
      pessimistic_number_of_days = 50 * 2.5 # 2.5 days per story point
      estimated_days_to_complete =
        ((optimistic_number_of_days + (4 * most_likely_number_of_days) + pessimistic_number_of_days) / 6).round
      expect(subject).to eq((estimated_days_to_complete / 5.0).round(1)) # Divided by 5 because of work days in a week
    end

    it 'returns the expected rounded number' do
      expect(subject).to eq(15.8)
    end
  end

  describe '#pert_formula' do
    subject do
      described_class.new(
        story_points: story_points,
        optimistic: optimistic,
        most_likely: most_likely,
        pessimistic: pessimistic,
        start_date: start_date
      ).pert_formula
    end

    let(:story_points) { 50 }
    let(:optimistic) { 1 }
    let(:most_likely) { 1.5 }
    let(:pessimistic) { 2.5 }
    let(:start_date) { nil }

    it 'returns the appropriate formula' do
      optimistic_number_of_days = 50 * 1 # 1 day per story point
      most_likely_number_of_days = 50 * 1.5 # 1.5 days per story point
      pessimistic_number_of_days = 50 * 2.5 # 2.5 days per story point
      expect(subject).to eq(
        "(#{optimistic_number_of_days} + (4 * #{most_likely_number_of_days}) + #{pessimistic_number_of_days}) / 6"
      )
    end
  end
end
