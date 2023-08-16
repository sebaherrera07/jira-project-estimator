# frozen_string_literal: true

class WeeklyEarnedValueItem
  def initialize(earned_value_items:, previous_cumulative_earned_value:, week:)
    @earned_value_items = earned_value_items
    @previous_cumulative_earned_value = previous_cumulative_earned_value
    @week = week
  end

  def cumulative_earned_value
    @cumulative_earned_value ||= (previous_cumulative_earned_value + earned_value).round(2)
  end

  def earned_value
    return 0 if earned_value_items.blank?

    @earned_value ||= earned_value_items.sum(&:earned_value).round(2)
  end

  def points_completed
    return 0 if earned_value_items.blank?

    @points_completed ||= earned_value_items.sum(&:points)
  end

  def week_dates
    @week_dates ||= "#{formatted_beginning_of_week} - #{formatted_end_of_week}"
  end

  def week_number
    @week_number ||= week.number
  end

  private

  attr_reader :earned_value_items, :previous_cumulative_earned_value, :week

  def formatted_beginning_of_week
    week.start_date.strftime('%Y-%m-%d')
  end

  def formatted_end_of_week
    week.end_date.strftime('%Y-%m-%d')
  end
end
