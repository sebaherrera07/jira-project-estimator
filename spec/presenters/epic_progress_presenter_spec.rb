# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicProgressPresenter do
  describe '#total_story_points' do
    subject { described_class.new(issues).total_story_points }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has no estimated issues' do
      let(:issues) { build_list(:issue, rand(1..2), :unestimated) }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has estimated issues' do
      let(:estimated_issues) { build_list(:issue, rand(1..2)) }
      let(:unestimated_issues) { build_list(:issue, rand(1..2), :unestimated) }
      let(:issues) { estimated_issues + unestimated_issues }

      it 'returns the sum of story points' do
        expect(subject).to eq(estimated_issues.sum(&:story_points))
      end
    end
  end

  # TODO: add missing specs
end
