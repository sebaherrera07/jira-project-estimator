# frozen_string_literal: true

# == Schema Information
#
# Table name: estimations
#
#  id                               :bigint           not null, primary key
#  avg_weekly_earned_value          :decimal(7, 2)    not null
#  filters_applied                  :jsonb
#  last_completed_week_number       :integer          not null
#  remaining_earned_value           :decimal(5, 2)    not null
#  remaining_weeks                  :decimal(7, 2)    not null
#  remaining_weeks_with_uncertainty :decimal(7, 2)
#  total_points                     :integer          not null
#  uncertainty_level                :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  epic_id                          :string           not null, indexed
#  project_id                       :string           default(""), not null, indexed
#  user_id                          :bigint           indexed
#
# Indexes
#
#  index_estimations_on_epic_id     (epic_id)
#  index_estimations_on_project_id  (project_id)
#  index_estimations_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Estimation < ApplicationRecord
  has_dto

  belongs_to :user, optional: true, inverse_of: nil

  enum uncertainty_level: UncertaintyLevel::LEVELS

  validates :avg_weekly_earned_value, :epic_id, :last_completed_week_number, :project_id, :remaining_earned_value,
            :remaining_weeks, :total_points, presence: true
  validates :last_completed_week_number, :total_points,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :avg_weekly_earned_value, :remaining_weeks, numericality: { greater_than_or_equal_to: 0 }
  validates :remaining_earned_value, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def estimated_finish_date
    beginning_of_week + remaining_weeks.weeks
  end

  def estimated_finish_date_with_uncertainty
    return if remaining_weeks_with_uncertainty.blank?

    beginning_of_week + remaining_weeks_with_uncertainty.weeks
  end

  private

  def beginning_of_week
    created_at.to_date.beginning_of_week
  end
end
