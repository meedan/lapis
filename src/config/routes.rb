require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get 'version', to: 'base_api#version'
      scope '/graphql' do
        post '/', to: 'graphql#create'
      end
      # Write your routes here!
    end
  end
end
