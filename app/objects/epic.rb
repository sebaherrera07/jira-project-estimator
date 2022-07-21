# frozen_string_literal: true

class Epic
  attr_reader :key, :labels, :project_key, :status, :summary

  def initialize(args)
    @key = args[:key]
    @labels = args[:labels]
    @project_key = args[:project_key]
    @status = args[:status]
    @summary = args[:summary]
  end

  def completed?
    status.downcase == 'done'
  end
end
