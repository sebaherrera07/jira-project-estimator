# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue do
  describe '#done?' do
    subject { issue.done? }

    context 'when status is Done' do
      let(:issue) { build(:issue, status: 'Done') }

      it { is_expected.to be_truthy }
    end

    context 'when status is not Done' do
      let(:issue) { build(:issue, status: 'In Progress') }

      it { is_expected.to be_falsey }
    end
  end

  describe '#to_do?' do
    subject { issue.to_do? }

    context 'when status is To Do' do
      let(:issue) { build(:issue, status: 'To Do') }

      it { is_expected.to be_truthy }
    end

    context 'when status is not To Do' do
      let(:issue) { build(:issue, status: 'In Progress') }

      it { is_expected.to be_falsey }
    end
  end

  describe '#started?' do
    subject { issue.started? }

    context 'when status is To Do' do
      let(:issue) { build(:issue, status: 'To Do') }

      it { is_expected.to be_falsey }
    end

    context 'when status is Done' do
      let(:issue) { build(:issue, status: 'Done') }

      it { is_expected.to be_falsey }
    end

    context 'when status is In Progress' do
      let(:issue) { build(:issue, status: 'In Progress') }

      it { is_expected.to be_truthy }
    end

    context 'when status is other' do
      let(:issue) { build(:issue, status: 'For QA') }

      it { is_expected.to be_truthy }
    end
  end

  describe '#estimated?' do
    subject { issue.estimated? }

    context 'when story points is present' do
      let(:issue) { build(:issue, story_points: 1) }

      it { is_expected.to be_truthy }
    end

    context 'when story points is zero' do
      let(:issue) { build(:issue, story_points: 0) }

      it { is_expected.to be_truthy }
    end

    context 'when story points is not present' do
      let(:issue) { build(:issue, story_points: nil) }

      it { is_expected.to be_falsey }
    end
  end

  describe '#finish_date' do
    subject { issue.finish_date }

    context 'when status is Done' do
      let(:issue) { build(:issue, status: 'Done', status_category_change_date: Time.zone.now) }

      it { is_expected.to eq issue.status_category_change_date }
    end

    context 'when status is not Done' do
      let(:issue) { build(:issue, status: 'In Progress', status_category_change_date: Time.zone.now) }

      it { is_expected.to be_nil }
    end
  end
end
