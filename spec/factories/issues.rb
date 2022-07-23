# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    created_date { Time.zone.now }
    epic_key { 'EPIC-1' }
    key { 'ISSUE-1' }
    labels { [] }
    project_key { 'PRO' }
    status { 'To Do' }
    status_category_change_date { Time.zone.now }
    story_points { 1 }
    summary { 'Summary' }

    initialize_with { new(attributes) }
  end
end
