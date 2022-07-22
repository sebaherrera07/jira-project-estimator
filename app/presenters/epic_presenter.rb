# frozen_string_literal: true

class EpicPresenter
  attr_reader :epic, :issues

  delegate :key, :project_key, :summary, :status, :labels, to: :epic

  def initialize(epic, issues = [])
    @epic = epic
    @issues = issues
  end

  def total_issues_count
    @total_issues_count ||= issues.count
  end

  def completed_issues_count
    @completed_issues_count ||= completed_issues.count
  end

  def remaining_issues_count
    @remaining_issues_count ||= total_issues_count - completed_issues_count
  end

  def unestimated_issues_count
    @unestimated_issues_count ||= issues.select { |issue| issue.story_points.nil? }.count
  end

  def total_story_points
    @total_story_points ||= estimated_issues.sum(&:story_points)
  end

  def completed_story_points
    @completed_story_points ||= completed_estimated_issues.sum(&:story_points)
  end

  def remaining_story_points
    @remaining_story_points ||= total_story_points - completed_story_points
  end

  def earned_value
    @earned_value ||= "#{earned_value_number}%"
  end

  def remaining_earned_value
    @remaining_earned_value ||= "#{100 - earned_value_number}%"
  end

  def avg_story_points_per_week_since_beginning
    3 # calculate this one
    # completed_issues.select{|x| x.finish_date < Time.zone.today.beginning_of_week}.sum(&:story_points) / 3
  end

  def avg_story_points_per_week_since_last_3_weeks
    0 # calculate this one
    # completed_issues.select{|x| x.finish_date < Time.zone.today.beginning_of_week}.sum(&:story_points) / 3
  end

  def estimated_weeks_to_complete_using_since_beggining_avg
    return "Avg is 0. Can't generate estimation." if avg_story_points_per_week_since_beginning.zero?

    @estimated_weeks_to_complete_using_since_beggining_avg ||= begin
      weeks = remaining_story_points / (avg_story_points_per_week_since_beginning * 1.0).round
      date = Time.zone.today.beginning_of_week + weeks.weeks
      "#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})"
    end
  end

  def estimated_weeks_to_complete_using_since_last_3_weeks_avg
    return "Avg is 0. Can't generate estimation." if avg_story_points_per_week_since_last_3_weeks.zero?

    @estimated_weeks_to_complete_using_since_last_3_weeks_avg ||= begin
      weeks = remaining_story_points / (avg_story_points_per_week_since_last_3_weeks * 1.0).round
      date = Time.zone.today.beginning_of_week + weeks.weeks
      "#{weeks} weeks (#{date.strftime('%a, %d %b %Y')})"
    end
  end

  private

  def estimated_issues
    @estimated_issues ||= issues.select { |issue| issue.story_points.present? }
  end

  def earned_value_number
    return 0 if total_story_points.zero?

    @earned_value_number ||= begin
      ratio = completed_story_points / (total_story_points * 1.0)
      (ratio * 100).round
    end
  end

  def completed_issues
    @completed_issues ||= issues.select(&:completed?)
  end

  def completed_estimated_issues
    @completed_estimated_issues ||= estimated_issues.select(&:completed?)
  end
end
