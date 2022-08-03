# frozen_string_literal: true

class EpicWeeklyEarnedValuePresenter
  def initialize(earned_value_items:, implementation_start_date:)
    @earned_value_items = earned_value_items
    @implementation_start_date = implementation_start_date
  end

  def weekly_earned_value_items
    return [] if earned_value_items.blank?

    @weekly_earned_value_items ||= begin
      result = []
      previous_cumulative_earned_value = 0
      weeks.each do |week|
        weekly_earned_value_item = new_weekly_earned_value_item(week, previous_cumulative_earned_value)
        result << weekly_earned_value_item
        previous_cumulative_earned_value += weekly_earned_value_item.earned_value
      end
      result
    end
  end

  private

  attr_reader :earned_value_items, :implementation_start_date

  def new_weekly_earned_value_item(week, previous_cumulative_earned_value)
    WeeklyEarnedValueItem.new(
      earned_value_items: earned_value_items_for(week.number),
      previous_cumulative_earned_value: previous_cumulative_earned_value,
      week: week
    )
  end

  def weeks
    return [new_week(1)] if earned_value_items.blank?

    @weeks ||= (1..earned_value_items.last.finish_week_number).map do |number|
      new_week(number)
    end
  end

  def earned_value_items_for(week_number)
    earned_value_items.select { |earned_value_item| earned_value_item.finish_week_number == week_number }
  end

  def new_week(number)
    Week.new(number: number, start_date: implementation_start_date + (number - 1).weeks)
  end
end
