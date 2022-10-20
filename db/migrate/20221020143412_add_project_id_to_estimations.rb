# frozen_string_literal: true

class AddProjectIdToEstimations < ActiveRecord::Migration[7.0]
  def change
    add_column :estimations, :project_id, :string, null: false, default: ''
    add_index :estimations, :project_id
  end
end
