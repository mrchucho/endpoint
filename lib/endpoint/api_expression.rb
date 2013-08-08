require 'active_support/concern'

module Endpoint
  module ApiExpression

    extend ActiveSupport::Concern

    module ClassMethods
      def describe(method, options={})
        options.symbolize_keys!
        @endpoint = true
        @describes ||= {}
        if options[:example]
          options[:examples] = [options.delete(:example)]
        end
        @describes[method] = options
      end

      def describes
        @describes || {}
      end

      def description_for(action)
        describes[action.to_sym] || {}
      end

      def arguments_for(action)
        description_for(action)[:args]
      end

      def examples_for(action)
        description_for(action)[:examples]
      end

      def endpoint?
        @endpoint
      end
    end

    def endpoint?
      self.class.endpoint?
    end

  end
end
