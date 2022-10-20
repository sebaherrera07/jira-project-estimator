# frozen_string_literal: true

class EpicEstimationHistoryPresenter
  def initialize(epic_id:)
    @epic_id = epic_id
  end

  def estimation_items
    Estimation.where(epic_id: epic_id).order(created_at: :desc).to_dto
  end

  private

  attr_reader :epic_id
end
