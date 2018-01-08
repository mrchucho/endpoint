Gem::Specification.new do |s|
  s.name        = 'endpoint'
  s.version     = '2.0.0'
  s.summary     = 'API Endpoint Explorer'
  s.description = 'API Endpoint Explorer. Extracted from Platform.'
  s.authors     = ['Ralph Churchill']
  s.email       = 'ralph.churchill@vitals.com'
  s.homepage    = 'https://github.com/organizations/mdx-dev'
  s.files       = [
    'Gemfile',
    'README.md',
    'VERSION',
    'app/assets/stylesheets/endpoint/style.css.scss',
    'app/controllers/endpoint/endpoint_explorer_controller.rb',
    'app/views/endpoint/endpoint_explorer/show.html.haml',
    'lib/endpoint.rb',
    'lib/endpoint/api_expression.rb',
    'lib/endpoint/cache.rake',
    'lib/endpoint/endpoint.rb',
    'lib/endpoint/endpoint_explorer.rb',
    'lib/endpoint/engine.rb',
    'lib/extensions/gherkin/formatter/explorer_formatter.rb',
  ]
  s.test_files  = [
    'spec/config/application.rb',
    'spec/config/environment.rb',
    'spec/endpoint_explorer_spec.rb',
    'spec/spec_helper.rb',
  ]
  s.add_dependency('rails', ['>= 4.2.0'])
  s.add_dependency('gherkin', ['~> 2.12.0'])
  s.add_dependency('sass-rails', ['~> 5.0.0'])
end
