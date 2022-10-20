# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicProgressPresenter do
  describe '#total_story_points' do
    subject { described_class.new(issues: issues).total_story_points }

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

  describe '#completed_story_points' do
    subject { described_class.new(issues: issues).completed_story_points }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has completed but not estimated issues' do
      let(:issues) { build_list(:issue, rand(1..2), :done, :unestimated) }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has estimated but not completed issues' do
      let(:issues) { build_list(:issue, rand(1..2), :in_progress) }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has completed and estimated issues' do
      let(:completed_estimated_issues) { build_list(:issue, rand(1..2), :done) }
      let(:completed_unestimated_issues) { build_list(:issue, rand(1..2), :done, :unestimated) }
      let(:issues) { completed_estimated_issues + completed_unestimated_issues }

      it 'returns the sum of story points' do
        expect(subject).to eq(completed_estimated_issues.sum(&:story_points))
      end
    end
  end

  describe '#remaining_story_points' do
    subject { described_class.new(issues: issues).remaining_story_points }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has issues' do
      let(:to_do_estimated_issues) { build_list(:issue, rand(1..2), :to_do) }
      let(:to_do_unestimated_issues) { build_list(:issue, rand(1..2), :to_do, :unestimated) }
      let(:in_progress_estimated_issues) { build_list(:issue, rand(1..2), :in_progress) }
      let(:in_progress_unestimated_issues) { build_list(:issue, rand(1..2), :in_progress, :unestimated) }
      let(:completed_estimated_issues) { build_list(:issue, rand(1..2), :done) }
      let(:completed_unestimated_issues) { build_list(:issue, rand(1..2), :done, :unestimated) }

      let(:issues) do
        to_do_estimated_issues + to_do_unestimated_issues +
          in_progress_estimated_issues + in_progress_unestimated_issues +
          completed_estimated_issues + completed_unestimated_issues
      end

      it 'returns the sum of remaining story points' do
        expect(subject).to eq(
          to_do_estimated_issues.sum(&:story_points) + in_progress_estimated_issues.sum(&:story_points)
        )
      end
    end
  end

  describe '#earned_value' do
    subject { described_class.new(issues: issues).earned_value }

    let(:issues) { build_list(:issue, rand(1..2)) }

    context 'when total_story_points is 0' do
      it 'returns 0%' do
        allow_any_instance_of(described_class).to receive(:total_story_points).and_return(0)
        expect(subject).to eq('0%')
      end
    end

    context 'when total_story_points is not 0' do
      context 'when completed_story_points is 0' do
        it 'returns 0%' do
          allow_any_instance_of(described_class).to receive(:total_story_points).and_return(35)
          allow_any_instance_of(described_class).to receive(:completed_story_points).and_return(0)
          expect(subject).to eq('0%')
        end
      end

      context 'when completed_story_points is not 0' do
        it 'returns the progress percentage' do
          allow_any_instance_of(described_class).to receive(:total_story_points).and_return(35)
          allow_any_instance_of(described_class).to receive(:completed_story_points).and_return(11)
          expect(subject).to eq('31%')
        end
      end
    end
  end

  describe '#remaining_earned_value' do
    subject { described_class.new(issues: issues).remaining_earned_value }

    let(:issues) { build_list(:issue, rand(1..2)) }

    context 'when total_story_points is 0' do
      it 'returns 100%' do
        allow_any_instance_of(described_class).to receive(:total_story_points).and_return(0)
        expect(subject).to eq(100)
      end
    end

    context 'when total_story_points is not 0' do
      context 'when completed_story_points is 0' do
        it 'returns 100%' do
          allow_any_instance_of(described_class).to receive(:total_story_points).and_return(35)
          allow_any_instance_of(described_class).to receive(:completed_story_points).and_return(0)
          expect(subject).to eq(100)
        end
      end

      context 'when completed_story_points is not 0' do
        it 'returns the progress percentage' do
          allow_any_instance_of(described_class).to receive(:total_story_points).and_return(35)
          allow_any_instance_of(described_class).to receive(:completed_story_points).and_return(11)
          expect(subject).to eq(69)
        end
      end
    end
  end

  describe '#unestimated_issues_count' do
    subject { described_class.new(issues: issues).unestimated_issues_count }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has no unestimated issues' do
      let(:issues) { build_list(:issue, rand(1..2)) }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has estimated and unestimated issues' do
      let(:estimated_issues) { build_list(:issue, rand(1..2)) }
      let(:unestimated_issues) { build_list(:issue, rand(1..2), :unestimated) }
      let(:issues) { estimated_issues + unestimated_issues }

      it 'returns the count of unestimated issues' do
        expect(subject).to eq(unestimated_issues.count)
      end
    end
  end

  describe '#any_unestimated_issues?' do
    subject { described_class.new(issues: issues).any_unestimated_issues? }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns false' do
        expect(subject).to be(false)
      end
    end

    context 'when epic has no unestimated issues' do
      let(:issues) { build_list(:issue, rand(1..2)) }

      it 'returns false' do
        expect(subject).to be(false)
      end
    end

    context 'when epic has estimated and unestimated issues' do
      let(:estimated_issues) { build_list(:issue, rand(1..2)) }
      let(:unestimated_issues) { build_list(:issue, rand(1..2), :unestimated) }
      let(:issues) { estimated_issues + unestimated_issues }

      it 'returns true' do
        expect(subject).to be(true)
      end
    end
  end

  describe '#completed_weeks_since_beginning' do
    subject do
      described_class.new(
        issues: issues,
        implementation_start_date: implementation_start_date
      ).completed_weeks_since_beginning
    end

    let(:issues) { build_list(:issue, rand(1..2)) }

    context 'when param implementation_start_date is nil' do
      let(:implementation_start_date) { nil }

      context 'when implementation start date cannot be calculated' do
        it 'returns 0' do
          allow_any_instance_of(ProjectImplementationStartDateCalculator).to receive(:calculate).and_return(nil)
          expect(subject).to eq(0)
        end
      end

      context 'when implementation start date can be calculated' do
        it 'returns the number of weeks' do
          allow_any_instance_of(ProjectImplementationStartDateCalculator).to receive(:calculate).and_return(
            3.weeks.ago.to_date
          )
          expect(subject).to eq(3)
        end
      end
    end

    context 'when param implementation_start_date is given' do
      let(:implementation_start_date) { 6.weeks.ago.to_date }

      it 'returns the number of weeks' do
        expect(subject).to eq(6)
      end
    end
  end
end
