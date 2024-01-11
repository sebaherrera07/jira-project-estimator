# frozen_string_literal: true

class EstimationsController < ApplicationController
  include ::EpicDetails

  def index
    @epic_presenter = epic_presenter
  end

  def show
    @estimation = Estimation.find(params[:id]).to_dto(
      methods: %i[estimated_finish_date estimated_finish_date_with_uncertainty],
      include: [:user]
    )
  end

  def create
    if new_estimation.save
      flash[:notice] = 'Estimation created successfully'
    else
      flash[:alert] = "Estimation could not be created. #{new_estimation.errors.full_messages.join(', ')}"
    end
    redirect_to_project_epic_estimations
  end

  private

  def new_estimation
    @new_estimation ||= EstimationGeneratorService.new(
      estimation_params: estimation_params,
      filters_applied: filters_applied,
      user_id: current_user.id
    ).generate
  end

  def estimation_params
    params.permit(:avg_weekly_earned_value, :category, :epic_id, :last_completed_week_number, :project_id,
                  :remaining_earned_value, :remaining_weeks, :remaining_weeks_with_uncertainty,
                  :total_points, :uncertainty_level)
  end

  def filters_applied
    @filters_applied ||= {
      expected_average: params[:expected_average].presence,
      implementation_start_date: params[:implementation_start_date].presence,
      labels: params[:labels].presence
    }.compact
  end

  def redirect_to_project_epic_estimations
    redirect_to project_epic_estimations_path(
      project_id: params[:project_id],
      epic_id: params[:epic_id],
      labels: params[:labels],
      expected_average: params[:expected_average],
      uncertainty_level: params[:uncertainty_level]
    )
  end
end
