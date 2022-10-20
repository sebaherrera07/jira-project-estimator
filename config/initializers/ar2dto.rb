# frozen_string_literal: true

AR2DTO.configure do |config|
  config.active_model_compliance = true
  config.except = []
  config.delete_suffix = nil
  config.add_suffix = 'DTO'
end
