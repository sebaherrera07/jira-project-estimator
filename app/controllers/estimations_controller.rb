# frozen_string_literal: true

class EstimationsController < ApplicationController
  include ::EpicDetails

  def index
    @epic_presenter = epic_presenter
  end

  def show
    @estimation = Estimation.find(params[:id]).to_dto(
      methods: %i[estimated_finish_date estimated_finish_date_with_uncertainty],
      include: [:user]
    )
  end
end
