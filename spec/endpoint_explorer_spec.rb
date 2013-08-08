require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Endpoint::EndpointExplorer do

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

#    context 'given a facility with id 210000001' do
#
#      # TODO: Should this use a mock controller/model perhaps instead of tying
#      # to a specific controller/model?
#      let(:facility) { FactoryGirl.build(:facility, id: 210000001) }
#
#      before do
#        Facility.stub(:first).and_return(facility)
#      end
#
#      it 'returns paths with an example' do
#        endpoint = subject.endpoints.detect{|e|e.name == 'facilities'}
#        path = endpoint.paths.detect { |p| p[:path] =~ /\/:id/ }
#        expect(path[:examples][0][:url]).to eq('/facilities/210000001')
#      end
#
#    end

#    context 'given bad data' do
#
#      # TODO: Should this use a mock controller/model perhaps instead of tying
#      # to a specific controller/model?
#      before do
#        FacilitiesController.stub(:examples_for).and_return(-> { {id: nil} })
#      end
#
#      it 'returns paths without error' do
#        endpoint = subject.endpoints.detect{|e|e.name == 'facilities'}
#        expect { endpoint.paths }.to_not raise_error
#      end
#
#    end

  end

end
