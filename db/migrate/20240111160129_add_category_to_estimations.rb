# frozen_string_literal: true

class AddCategoryToEstimations < ActiveRecord::Migration[7.1]
  def change
    add_column :estimations, :category, :integer, null: false, default: 1 # EstimationCategory::NEUTRAL
  end
end
