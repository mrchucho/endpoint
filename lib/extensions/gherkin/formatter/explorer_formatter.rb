require 'gherkin/formatter/json_formatter'

# Used to parse descriptions from .feature files
# for our API explorer
module Gherkin
  module Formatter
    class ExplorerFormatter < JSONFormatter
      def initialize
        super StringIO.new
      end
      def description
        @feature_hashes[0]['description']
      end
    end
  end
end

