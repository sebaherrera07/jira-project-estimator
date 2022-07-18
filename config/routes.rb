# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'projects#index'

  resources :projects, only: %i[index] do
    resources :epics, only: [:index] do
      resources :issues, only: [:index]
    end
  end
end
