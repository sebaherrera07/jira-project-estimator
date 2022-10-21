# frozen_string_literal: true

class EstimationGeneratorService
  def initialize(estimation_params:, filters_applied:, user_id:)
    @estimation_params = estimation_params
    @filters_applied = filters_applied
    @user_id = user_id
  end

  def generate
    Estimation.new(
      **estimation_general_attributes,
      **estimation_references,
      **estimation_uncertainty_attributes,
      filters_applied: filters_applied
    )
  end

  def estimation_general_attributes
    {
      avg_weekly_earned_value: estimation_params[:avg_weekly_earned_value].to_d,
      last_completed_week_number: estimation_params[:last_completed_week_number].to_i,
      remaining_earned_value: estimation_params[:remaining_earned_value].to_d,
      remaining_weeks: estimation_params[:remaining_weeks].to_d,
      total_points: estimation_params[:total_points].to_i
    }
  end

  def estimation_references
    {
      epic_id: estimation_params[:epic_id],
      project_id: estimation_params[:project_id],
      user_id: user_id
    }
  end

  def estimation_uncertainty_attributes
    uncertainty_level = estimation_params[:uncertainty_level].presence
    return {} if uncertainty_level.blank?

    {
      remaining_weeks_with_uncertainty: estimation_params[:remaining_weeks_with_uncertainty].to_d,
      uncertainty_level: uncertainty_level,
      uncertainty_percentage: UncertaintyLevel.new(uncertainty_level).percentage
    }
  end

  private

  attr_reader :estimation_params, :filters_applied, :user_id
end
