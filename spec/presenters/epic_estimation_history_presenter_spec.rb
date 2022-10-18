# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicEstimationHistoryPresenter do
  describe '#estimation_items' do
    subject { described_class.new(epic_id: epic_id).estimation_items }

    let(:epic_id) { build(:epic).key }

    context 'when no estimations exist' do
      it { is_expected.to be_empty }
    end

    context 'when estimations exist' do
      let!(:estimation1) { create(:estimation, epic_id: epic_id, created_at: '2022-09-11') }
      let!(:estimation2) { create(:estimation, epic_id: epic_id, created_at: '2022-10-18') }

      it { is_expected.to eq([estimation2, estimation1]) }
    end
  end
end
