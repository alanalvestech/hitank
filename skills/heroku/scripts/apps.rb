# List all Heroku apps
# Usage: ruby scripts/apps.rb

require_relative 'auth'

data = heroku_request(:get, '/apps')

data.each do |app|
  region  = app.dig('region', 'name') || '-'
  stack   = app.dig('stack', 'name') || app['stack'] || '-'
  updated = app['updated_at'] || '-'
  puts "#{app['name']}\t#{region}\t#{stack}\t#{updated}"
end
