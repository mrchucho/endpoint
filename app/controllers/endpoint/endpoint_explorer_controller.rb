class Endpoint::EndpointExplorerController < ApplicationController

  def show
    @explorer = Endpoint::EndpointExplorer.new
  end

end
