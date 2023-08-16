# frozen_string_literal: true

class PertController < ApplicationController
  def index
    return unless valid_params?

    @pert_presenter = PertPresenter.new(
      points: points,
      optimistic: optimistic,
      most_likely: most_likely,
      pessimistic: pessimistic,
      start_date: start_date
    )
  end

  private

  def points
    @points ||= params[:points].to_i
  end

  def start_date
    return if params[:start_date].blank?

    @start_date ||= Date.strptime(params[:start_date], '%Y-%m-%d')
  end

  def optimistic
    @optimistic ||= params[:optimistic].to_f
  end

  def most_likely
    @most_likely ||= params[:most_likely].to_f
  end

  def pessimistic
    @pessimistic ||= params[:pessimistic].to_f
  end

  def valid_params?
    return false if points.zero?
    return false if optimistic.zero?
    return false if most_likely.zero?
    return false if pessimistic.zero?

    true
  end
end
