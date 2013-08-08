require 'gherkin/parser/parser'

module Endpoint
  class Endpoint

    EXCLUDE_ACTIONS = %w(new edit)
    EXCLUDE_PATHS_REGEX = /excluded\-path/ # for example

      def initialize(controller)
        @controller = controller
        assert_valid_controller
        assert_valid_endpoint
      end

    def name
      @name ||= controller
    end

    def formats
      @formats ||= _formats
    end

    def description
      @description ||= _description
    end

    def paths
      @paths ||= _paths
    end

    def inspect
      attributes_as_nice_string = \
        %w(name formats description paths).map do |name|
        "#{name}: #{self.send(name).inspect}"
        end.compact.join(", ")
        "#<#{self.class} #{attributes_as_nice_string}>"
    end

    protected

    def assert_valid_controller
      raise "#{controller} is not a valid controller" unless controller_class
    end

    def assert_valid_endpoint
      raise "#{controller} is not a valid api endpoint." unless controller_class.respond_to?(:endpoint?) && controller_class.endpoint?
    end

    def controller
      @controller
    end

    def controller_class
      @controller_class ||= Object.const_get((controller + '_controller').classify) rescue nil
    end

    def controller_routes
      Rails.application.routes.routes.select { |route| route.defaults[:controller] == controller}
    end

    def _formats
      controller_class.mimes_for_respond_to.keys.map do |format|
        case format
        when :html
          'html (default)'
        else
          format.to_s
        end
      end.sort
    end

    def _description
      formatter = Gherkin::Formatter::ExplorerFormatter.new
      parser = Gherkin::Parser::Parser.new(formatter)

      source = "features/endpoints/#{controller}.feature"
      path = File.expand_path(File.dirname(__FILE__) + '/../../' + source)
      parser.parse(IO.read(path), path, 0)
      formatter.done
      description = formatter.description
    rescue
      description = ""
    end

    def _paths
      [].tap do |paths|
        controller_routes.each do |route|
          next if exclude_route(route)
          paths << build_path(route)
        end
      end
    end

    def exclude_route(route)
      EXCLUDE_ACTIONS.include?(route.defaults[:action]) || route.path.spec.to_s =~ EXCLUDE_PATHS_REGEX || !controller_class.describes[route.defaults[:action].to_sym]
    end

    def build_path(route)
      action = route.defaults[:action]
      verb = route.verb.inspect.scan(/[A-Z]/).join

      {
        method: verb,
        path: route.path.spec.to_s,
        args: args_for_action(action),
        examples: examples_for_action_verb(action, verb)
      }
    end

    def args_for_action(action)
      controller_class.arguments_for(action)
    end

    def examples_for_action_verb(action, verb)
      examples = controller_class.examples_for(action)
      Array(examples).map do |ex|
        {body: '', url: ''}.tap do |link|
          if ex.respond_to?(:call)
            params = (ex.call rescue nil)
          else
            params = ex
          end
          if params
            begin
              if %w(PUT PATCH).include?(verb)
                link[:body] = Rails.application.routes.url_helpers.url_for({controller: controller, action: :show, only_path: true}.merge(params.slice(:id)))
                link[:url] = Rails.application.routes.url_helpers.url_for({controller: controller, action: :edit, only_path: true}.merge(params.slice(:id)))
              elsif verb == "POST"
                link[:body] = Rails.application.routes.url_helpers.url_for({controller: controller, action: :index, only_path: true}.merge(params))

                link[:url] = Rails.application.routes.url_helpers.url_for({controller: controller, action: :new, only_path: true}.merge(params))
              else
                link[:body] = link[:url] = Rails.application.routes.url_helpers.url_for({controller: self.name, action: action, only_path: true}.merge(params))
              end
            rescue ActionController::UrlGenerationError
              # This can happen when the parameter data
              # is missing/invalid (i.e. a nil id)
              # Ignore. Just don't set the link/body in
              # this case.
            end
          end
        end
      end.compact
    end
  end
end
