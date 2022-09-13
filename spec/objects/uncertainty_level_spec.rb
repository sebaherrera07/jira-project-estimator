# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UncertaintyLevel do
  let(:uncertainty_level) { build(:uncertainty_level) }

  describe '#to_s' do
    subject { uncertainty_level.to_s }

    context 'when level is nil' do
      let(:uncertainty_level) { build(:uncertainty_level, :nil) }

      it { is_expected.to be_nil }
    end

    context 'when level is low' do
      let(:uncertainty_level) { build(:uncertainty_level, :low) }

      it { is_expected.to eq 'Low' }
    end

    context 'when level is medium' do
      let(:uncertainty_level) { build(:uncertainty_level, :medium) }

      it { is_expected.to eq 'Medium' }
    end

    context 'when level is high' do
      let(:uncertainty_level) { build(:uncertainty_level, :high) }

      it { is_expected.to eq 'High' }
    end

    context 'when level is very high' do
      let(:uncertainty_level) { build(:uncertainty_level, :very_high) }

      it { is_expected.to eq 'Very high' }
    end
  end

  describe '#percentage' do
    subject { uncertainty_level.percentage }

    context 'when level is nil' do
      let(:uncertainty_level) { build(:uncertainty_level, :nil) }

      it { is_expected.to eq 0 }
    end

    context 'when level is low' do
      let(:uncertainty_level) { build(:uncertainty_level, :low) }

      it { is_expected.to eq(10) }
      it { is_expected.to eq(ENV['LOW_UNCERTAINTY_PERCENTAGE'].to_f) }
    end

    context 'when level is medium' do
      let(:uncertainty_level) { build(:uncertainty_level, :medium) }

      it { is_expected.to eq(20) }
      it { is_expected.to eq(ENV['MEDIUM_UNCERTAINTY_PERCENTAGE'].to_f) }
    end

    context 'when level is high' do
      let(:uncertainty_level) { build(:uncertainty_level, :high) }

      it { is_expected.to eq(50) }
      it { is_expected.to eq(ENV['HIGH_UNCERTAINTY_PERCENTAGE'].to_f) }
    end

    context 'when level is very high' do
      let(:uncertainty_level) { build(:uncertainty_level, :very_high) }

      it { is_expected.to eq(100) }
      it { is_expected.to eq(ENV['VERY_HIGH_UNCERTAINTY_PERCENTAGE'].to_f) }
    end
  end
end
