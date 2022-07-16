# frozen_string_literal: true

class Issue
  attr_reader :key, :project_key, :epic_key, :summary, :status, :labels, :story_points, :finish_date

  def initialize(args)
    @key = args[:key]
    @project_key = args[:project_key]
    @epic_key = args[:epic_key]
    @summmary = args[:summary]
    @status = args[:status]
    @labels = args[:labels]
    @story_points = args[:story_points]
    @finish_date = args[:finish_date] if status == 'Done'
  end
end
