# frozen_string_literal: true

class CreateEstimations < ActiveRecord::Migration[7.0]
  def change
    create_table :estimations do |t|
      t.decimal :avg_weekly_earned_value, null: false, precision: 7, scale: 2
      t.string :epic_id, null: false, index: true
      t.jsonb :filters_applied, null: true
      t.integer :last_completed_week_number, null: false
      t.decimal :remaining_earned_value, null: false, precision: 5, scale: 2
      t.decimal :remaining_weeks, null: false, precision: 7, scale: 2
      t.decimal :remaining_weeks_with_uncertainty, null: true, precision: 7, scale: 2
      t.integer :total_points, null: false
      t.integer :uncertainty_level, null: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
