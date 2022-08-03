# frozen_string_literal: true

class Week
  attr_reader :number, :start_date, :end_date

  def initialize(number:, start_date:)
    @number = number # usually relative from a project implementation start date, starting from 1
    @start_date = start_date.beginning_of_week.to_date
    @end_date = start_date.end_of_week.to_date
  end
end
