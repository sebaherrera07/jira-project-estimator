# frozen_string_literal: true

class IssuesController < ApplicationController
  include ::EpicDetails

  def index
    @epic_presenter = epic_presenter
  end
end
