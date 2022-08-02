# frozen_string_literal: true

class EpicEarnedValuePresenter
  def initialize(completed_issues:, total_story_points:, implementation_start_date:)
    @completed_issues = completed_issues.sort_by(&:finish_date)
    @total_story_points = total_story_points
    @implementation_start_date = implementation_start_date
  end

  def earned_value_items
    @earned_value_items ||= begin
      result = []
      previous_cumulative_earned_value = 0
      completed_issues.each do |completed_issue|
        earned_value_item = new_earned_value_item(completed_issue, previous_cumulative_earned_value)
        result << earned_value_item
        previous_cumulative_earned_value += earned_value_item.earned_value
      end
      result
    end
  end

  private

  attr_reader :completed_issues, :total_story_points, :implementation_start_date

  def new_earned_value_item(completed_issue, previous_cumulative_earned_value)
    EarnedValueItem.new(
      completed_issue: completed_issue,
      previous_cumulative_earned_value: previous_cumulative_earned_value,
      total_story_points: total_story_points,
      implementation_start_date: implementation_start_date
    )
  end
end
