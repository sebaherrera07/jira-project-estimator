# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users

  # Defines the root path route ("/")
  unauthenticated do
    get '/', to: redirect('users/sign_in')
    root 'devise/sessions#new', as: :unauthenticated_root
  end

  authenticated :user do
    get '/', to: redirect('/projects')
    root 'projects#index'
  end

  resources :projects, only: %i[index] do
    resources :epics, only: %i[index show] do
      resources :issues, only: [:index]
      resources :progress, only: [:index]
      resources :estimations, only: %i[index show]
    end
  end

  resources :pert, only: %i[index]

  resources :about, only: %i[index]
end
