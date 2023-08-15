# frozen_string_literal: true

class Epic
  attr_reader :key, :labels, :project_key, :summary, :start_date

  def initialize(args)
    @key = args[:key]
    @labels = args[:labels]
    @project_key = args[:project_key]
    @summary = args[:summary]
    @start_date = args[:start_date]&.to_datetime
  end
end
