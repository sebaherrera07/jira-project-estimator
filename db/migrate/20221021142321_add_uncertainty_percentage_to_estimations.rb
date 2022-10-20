# frozen_string_literal: true

class AddUncertaintyPercentageToEstimations < ActiveRecord::Migration[7.0]
  def change
    add_column :estimations, :uncertainty_percentage, :decimal, null: true, precision: 5, scale: 2
  end
end
