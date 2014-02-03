class Endpoint::EndpointExplorerController < ApplicationController

  def show
    expire_fragment('endpoint-explorer') if params.key?('expire-cache')
    @explorer = Endpoint::EndpointExplorer.new
  end

end
