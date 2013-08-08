require 'gherkin/parser/parser'

module Endpoint
class EndpointExplorer
  EXCLUDE_CONTROLLERS_REGEX = /^devise|^explorer|^application|^static\_pages/i

  def endpoints
    [].tap do |result|
      controller_endpoints.each do |controller|
          endpoint = Endpoint.new(controller)
          result << endpoint
      end
    end
  end

  protected

  def filtered_controllers
    Rails.application.routes.routes.map { |route| route.defaults[:controller]}.reject do |controller|
      controller.nil? || controller =~ EXCLUDE_CONTROLLERS_REGEX
    end.uniq
  end

  def controller_endpoints
    filtered_controllers.keep_if do |controller|
      controller_class = (Object.const_get((controller + '_controller').classify) rescue nil)
      controller_class.respond_to?(:endpoint?) && controller_class.endpoint?
    end
  end

end
end
