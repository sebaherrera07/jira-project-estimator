# frozen_string_literal: true

class EpicPresenter
  attr_reader :epic, :issues

  delegate :key, :project_key, :summary, :status, :labels, to: :epic

  def initialize(epic, issues = [])
    @epic = epic
    @issues = issues
  end

  def total_issues_count
    issues.count
  end

  delegate :count, to: :completed_issues, prefix: true

  def remaining_issues_count
    total_issues_count - completed_issues_count
  end

  def total_story_points
    issues.sum(&:story_points)
  end

  def completed_story_points
    completed_issues.sum(&:story_points)
  end

  def remaining_story_points
    total_story_points - completed_story_points
  end

  def earned_value
    "#{earned_value_number}%"
  end

  def remaining_earned_value
    "#{100 - earned_value_number}%"
  end

  def avg_story_points_per_week_since_beginning
    3 # calculate this one
  end

  def avg_story_points_per_week_since_last_3_weeks
    2 # calculate this one
  end

  def estimated_weeks_to_complete_using_since_beggining_avg
    weeks = remaining_story_points / avg_story_points_per_week_since_beginning
    date = Time.zone.today.beginning_of_week + weeks.weeks
    "#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})"
  end

  def estimated_weeks_to_complete_using_since_last_3_weeks_avg
    weeks = remaining_story_points / avg_story_points_per_week_since_last_3_weeks
    date = Time.zone.today.beginning_of_week + weeks.weeks
    "#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})"
  end

  private

  def earned_value_number
    (completed_story_points / total_story_points * 100).round
  end

  def completed_issues
    issues.select(&:completed?)
  end
end
