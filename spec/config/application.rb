require 'rails/all'

Bundler.require(:development, Rails.env)

module Endpoint
  class Application < Rails::Application
    config.eager_load = false
  end
end
