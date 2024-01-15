# frozen_string_literal: true

class EpicEstimationHistoryPresenter
  def initialize(epic_id:, labels_filter: nil)
    @epic_id = epic_id
    @labels_filter = labels_filter
  end

  def estimation_items
    items = Estimation.where(epic_id: epic_id).order(created_at: :desc)
    items = items.where("filters_applied->>'labels' = ?", labels_filter) if labels_filter.present?
    items.to_dto(
      methods: %i[estimated_finish_date estimated_finish_date_with_uncertainty label]
    )
  end

  private

  attr_reader :epic_id, :labels_filter
end
