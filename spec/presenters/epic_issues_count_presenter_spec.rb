# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicIssuesCountPresenter do
  describe '#total_issues_count' do
    subject { described_class.new(issues: issues).total_issues_count }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has issues' do
      let(:issues) { build_list(:issue, rand(1..2)) }

      it 'returns the total number of issues' do
        expect(subject).to eq(issues.count)
      end
    end
  end

  describe '#completed_issues_count' do
    subject { described_class.new(issues: issues).completed_issues_count }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has no completed issues' do
      let(:issues) { build_list(:issue, rand(1..2), :in_progress) }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has completed issues' do
      let(:to_do_issues) { build_list(:issue, rand(1..2), :to_do) }
      let(:completed_issues) { build_list(:issue, rand(1..2), :done) }
      let(:issues) { to_do_issues + completed_issues }

      it 'returns the total number of completed issues' do
        expect(subject).to eq(completed_issues.count)
      end
    end
  end

  describe '#remaining_issues_count' do
    subject { described_class.new(issues: issues).remaining_issues_count }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has no remaining issues' do
      let(:issues) { build_list(:issue, rand(1..2), :done) }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has remaining issues' do
      let(:to_do_issues) { build_list(:issue, rand(1..2), :to_do) }
      let(:in_progress_issues) { build_list(:issue, rand(1..2), :in_progress) }
      let(:other_issues) { build_list(:issue, rand(1..2), status: 'Other') }
      let(:completed_issues) { build_list(:issue, rand(1..2), :done) }
      let(:issues) { to_do_issues + in_progress_issues + other_issues + completed_issues }

      it 'returns the total number of remaining issues' do
        expect(subject).to eq(issues.count - completed_issues.count)
      end
    end
  end

  describe '#started_issues_count' do
    subject { described_class.new(issues: issues).started_issues_count }

    context 'when epic has no issues' do
      let(:issues) { [] }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has no started issues' do
      let(:to_do_issues) { build_list(:issue, rand(1..2), :to_do) }
      let(:completed_issues) { build_list(:issue, rand(1..2), :done) }
      let(:issues) { to_do_issues + completed_issues }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has started issues' do
      let(:to_do_issues) { build_list(:issue, rand(1..2), :to_do) }
      let(:in_progress_issues) { build_list(:issue, rand(1..2), :in_progress) }
      let(:other_issues) { build_list(:issue, rand(1..2), status: 'Other') }
      let(:completed_issues) { build_list(:issue, rand(1..2), :done) }
      let(:issues) { to_do_issues + in_progress_issues + other_issues + completed_issues }

      it 'returns the total number of started issues' do
        expect(subject).to eq(in_progress_issues.count + other_issues.count)
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

    context 'when epic has only estimated issues' do
      let(:issues) { build_list(:issue, rand(1..2)) }

      it 'returns 0' do
        expect(subject).to eq(0)
      end
    end

    context 'when epic has unestimated issues' do
      let(:estimated_issues) { build_list(:issue, rand(1..2)) }
      let(:unestimated_issues) { build_list(:issue, rand(1..2), :unestimated) }
      let(:issues) { estimated_issues + unestimated_issues }

      it 'returns the total number of unestimated issues' do
        expect(subject).to eq(unestimated_issues.count)
      end
    end
  end
end
