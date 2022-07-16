# frozen_string_literal: true

class Project
  attr_reader :key, :name

  def initialize(args)
    @key = args[:key]
    @name = args[:name]
  end
end
