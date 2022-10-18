# frozen_string_literal: true

class EstimationsController < ApplicationController
  include ::EpicDetails

  def index
    @epic_presenter = epic_presenter
  end

  # def show
  #   # TODO: Implement to see more details about an estimation
  # end
end
