require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class MocksController < ActionController::Base
  include Endpoint::ApiExpression
  respond_to :json, :html
  describe :show, output: :resource, example: ->{{id: 1234}}
  def show
    head(200)
  end
end

describe Endpoint::EndpointExplorer do

  before do
    Rails.application.routes.draw do
      resources :mocks
    end
  end
  after do
    Rails.application.reload_routes!
  end

  subject { Endpoint::EndpointExplorer.new }

  describe '#endpoints' do

    it 'returns the list of endpoints and formats' do
      endpoints = subject.endpoints
      expect(endpoints.size).to be > 0
      expect(
        endpoints.all?{|e| e.name && e.formats}
      ).to eq(true)
    end

    it 'returns endpoint paths with information about path method and params' do
      endpoints = subject.endpoints
      # Find the first path for a single resource with id
      path = endpoints.map(&:paths).flatten.detect { |p| p[:path] =~ /\/:id/ }
      expect(path[:method]).to eq('GET')
      expect(path[:path]).to match(/\w+\/:id\(\.:format\)/)
    end

    context 'given a "resource" with id 1234' do

      it 'returns paths with an example' do
        endpoint = subject.endpoints.detect{|e|e.name == 'mocks'}
        path = endpoint.paths.detect { |p| p[:path] =~ /\/:id/ }
        expect(path[:examples][0][:url]).to eq('/mocks/1234')
      end

    end

    context 'given bad data' do

      before do
        MocksController.stub(:examples_for).and_return(-> { {id: nil} })
      end

      it 'returns paths without error' do
        endpoint = subject.endpoints.detect{|e|e.name == 'mocks'}
        expect { endpoint.paths }.to_not raise_error
      end

    end

  end

end
