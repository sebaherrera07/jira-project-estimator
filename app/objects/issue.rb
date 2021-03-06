# frozen_string_literal: true

class Issue
  attr_reader :created_date,
              :epic_key,
              :key,
              :labels,
              :project_key,
              :status,
              :status_category_change_date,
              :story_points,
              :summary

  def initialize(args)
    @created_date = args[:created_date]
    @epic_key = args[:epic_key]
    @key = args[:key]
    @labels = args[:labels]
    @project_key = args[:project_key]
    @status = args[:status]
    @status_category_change_date = args[:status_category_change_date]&.to_datetime
    @story_points = args[:story_points]&.round
    @summary = args[:summary]
  end

  def estimated?
    story_points.present?
  end

  def to_do?
    status.downcase == 'to do'
  end

  def done?
    status.downcase == 'done'
  end

  def started?
    !to_do? && !done?
  end

  def finish_date
    return unless done?

    status_category_change_date
  end
end
