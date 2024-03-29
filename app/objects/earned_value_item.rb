# frozen_string_literal: true

class EarnedValueItem
  def initialize(completed_issue:, previous_cumulative_earned_value:, total_points:, implementation_start_date:)
    @completed_issue = completed_issue
    @previous_cumulative_earned_value = previous_cumulative_earned_value
    @total_points = total_points
    @implementation_start_date = implementation_start_date # it's for the project, not the issue
  end

  def cumulative_earned_value
    @cumulative_earned_value ||= (previous_cumulative_earned_value + earned_value).round(2)
  end

  def earned_value
    return 0 if total_points.zero? || points.nil? || points.zero?

    @earned_value ||= (points / total_points.to_f * 100).round(2)
  end

  def finish_date
    @finish_date ||= completed_issue.finish_date
  end

  def finish_week_dates
    @finish_week_dates ||= "#{formatted_beginning_of_week} - #{formatted_end_of_week}"
  end

  def finish_week_number
    @finish_week_number ||= implementation_start_date.step(finish_date, 7).count
  end

  def issue_key
    @issue_key ||= completed_issue.key
  end

  def points
    # Given that an issue can be completed without having points, we assign 0 to it.
    # Handling this in a better way can be a possible improvement to do in the future.
    @points ||= completed_issue.points || 0
  end

  private

  attr_reader :completed_issue, :previous_cumulative_earned_value, :total_points, :implementation_start_date

  def formatted_beginning_of_week
    finish_date.beginning_of_week.strftime('%Y-%m-%d')
  end

  def formatted_end_of_week
    finish_date.end_of_week.strftime('%Y-%m-%d')
  end
end
