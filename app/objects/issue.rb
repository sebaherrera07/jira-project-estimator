# frozen_string_literal: true

class Issue
  attr_reader :created_date,
              :epic_key,
              :key,
              :labels,
              :project_key,
              :status,
              :status_change_date,
              :points,
              :summary

  def initialize(args)
    @created_date = args[:created_date]
    @epic_key = args[:epic_key]
    @key = args[:key]
    @labels = args[:labels]
    @project_key = args[:project_key]
    @status = args[:status]
    @status_change_date = args[:status_change_date]&.to_datetime
    @points = args[:points]&.round
    @summary = args[:summary]
  end

  def estimated?
    points.present?
  end

  def to_do?
    list = (['to do'] + ENV.fetch('TO_DO_STATUSES', '').split(',').map(&:downcase)).uniq
    list.include?(status.downcase)
  end

  def done?
    list = (['done'] + ENV.fetch('DONE_STATUSES', '').split(',').map(&:downcase)).uniq
    list.include?(status.downcase)
  end

  def started?
    !to_do? && !done?
  end

  def finish_date
    return unless done?

    status_change_date
  end
end
