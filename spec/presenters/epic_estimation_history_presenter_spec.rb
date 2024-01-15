# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EpicEstimationHistoryPresenter do
  describe '#estimation_items' do
    subject { described_class.new(epic_id: epic_id, labels_filter: labels_filter).estimation_items }

    let(:epic_id) { build(:epic).key }
    let(:labels_filter) { nil }

    context 'when no estimations exist' do
      it { is_expected.to be_empty }
    end

    context 'when estimations exist' do
      let!(:estimation1) { create(:estimation, epic_id: epic_id, created_at: '2022-09-11') }
      let!(:estimation2) { create(:estimation, epic_id: epic_id, created_at: '2022-10-18') }

      it 'returns EstimationDTOs' do
        expect(subject).to all(be_a(EstimationDTO))
      end

      it 'returns estimations ordered by created_at descending' do
        expect(subject).to eq([estimation2.to_dto, estimation1.to_dto])
      end
    end

    context 'when filtering by label' do
      let!(:estimation1) do
        create(:estimation, epic_id: epic_id, created_at: '2022-09-11', filters_applied: { labels: 'scope1' })
      end
      let!(:estimation2) do
        create(:estimation, epic_id: epic_id, created_at: '2022-10-18', filters_applied: { labels: 'scope1' })
      end
      let(:labels_filter) { 'scope1' }

      before do
        create(:estimation, epic_id: epic_id, created_at: '2022-10-18', filters_applied: { labels: 'scope2' })
      end

      it 'returns EstimationDTOs' do
        expect(subject).to all(be_a(EstimationDTO))
      end

      it 'returns estimations ordered by created_at descending' do
        expect(subject).to eq([estimation2.to_dto, estimation1.to_dto])
      end
    end
  end
end
