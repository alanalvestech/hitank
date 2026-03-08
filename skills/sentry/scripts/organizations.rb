# List all Sentry organizations
# Usage: ruby scripts/organizations.rb

require_relative 'auth'

data = sentry_request(:get, '/organizations/')

data.each do |org|
  slug   = org['slug'] || '-'
  name   = org['name'] || '-'
  status = org.dig('status', 'id') || '-'
  puts "#{slug}\t#{name}\t#{status}"
end
