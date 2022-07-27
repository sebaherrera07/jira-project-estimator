# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get '/', to: redirect('/projects')
  root 'projects#index'

  resources :projects, only: %i[index] do
    resources :epics, only: %i[index show] do
      resources :issues, only: [:index]
      resources :progress, only: [:index]
    end
  end
end
