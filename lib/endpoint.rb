if defined? Rails
  require 'endpoint/engine'
  require 'endpoint/endpoint'
  require 'endpoint/endpoint_explorer'
  require 'endpoint/api_expression'
  module Endpoint
    class Railtie < Rails::Railtie
      rake_tasks do
        load 'endpoint/cache.rake'
      end
    end
  end
end
