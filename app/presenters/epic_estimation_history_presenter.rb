# frozen_string_literal: true

class EpicEstimationHistoryPresenter
  def initialize(epic_id:)
    @epic_id = epic_id
  end

  def estimation_items
    # TODO: avoid exposing active record objects
    Estimation.where(epic_id: epic_id).order(created_at: :desc)
  end

  private

  attr_reader :epic_id
end
