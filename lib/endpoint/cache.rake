namespace :endpoint do
  namespace :cache do

    desc 'Clear Endpoint Cache'
    task :clear => :environment do
      ActionController::Base.new.expire_fragment(
        'endpoint-explorer', options = nil
      )
      puts "Cache cleared"
    end

  end
end
