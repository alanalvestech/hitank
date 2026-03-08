# List DigitalOcean App Platform apps
# Usage: ruby scripts/apps.rb

require_relative 'auth'

data = do_request(:get, '/apps')

(data['apps'] || []).each do |app|
  id         = app['id'] || '-'
  name       = app.dig('spec', 'name') || '-'
  region     = app.dig('region', 'slug') || app['region'] || '-'
  live_url   = app['live_url'] || '-'
  updated_at = app['updated_at'] || '-'
  puts "#{id}\t#{name}\t#{region}\t#{live_url}\t#{updated_at}"
end
