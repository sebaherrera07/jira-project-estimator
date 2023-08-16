# frozen_string_literal: true

class PertPresenter
  def initialize(points:, optimistic:, most_likely:, pessimistic:, start_date: nil)
    @points = points
    @optimistic = optimistic
    @most_likely = most_likely
    @pessimistic = pessimistic
    @start_date = start_date
  end

  def estimated_days_to_complete
    @estimated_days_to_complete ||=
      ((optimistic_number_of_days + (4 * most_likely_number_of_days) + pessimistic_number_of_days) / 6).round
  end

  def estimated_finish_date
    return if start_date.blank?

    @estimated_finish_date ||= (start_date + estimated_weeks_to_complete.weeks).strftime('%a, %d %b %Y')
  end

  def estimated_weeks_to_complete
    # Divided by 5 because there are 5 work days in a week
    @estimated_weeks_to_complete ||= (estimated_days_to_complete / 5.0).round(1)
  end

  def pert_formula
    @pert_formula ||=
      "(#{optimistic_number_of_days} + (4 * #{most_likely_number_of_days}) + #{pessimistic_number_of_days}) / 6"
  end

  private

  def optimistic_number_of_days
    @optimistic_number_of_days ||= optimistic * points
  end

  def most_likely_number_of_days
    @most_likely_number_of_days ||= most_likely * points
  end

  def pessimistic_number_of_days
    @pessimistic_number_of_days ||= pessimistic * points
  end

  attr_reader :points, :optimistic, :most_likely, :pessimistic, :start_date
end
