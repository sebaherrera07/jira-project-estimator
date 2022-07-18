# frozen_string_literal: true

class Epic
  attr_reader :key, :project_key, :summary, :status, :labels

  def initialize(args)
    @key = args[:key]
    @project_key = args[:project_key]
    @summary = args[:summary]
    @status = args[:status]
    @labels = args[:labels]
  end

  def completed?
    status == 'Done'
  end
end
