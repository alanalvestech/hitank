# List all Cloudflare zones (domains)
# Usage: ruby scripts/zones.rb

require_relative 'auth'

data = cf_request(:get, '/zones?per_page=50')

unless data['success']
  abort "Error: #{(data['errors'] || []).map { |e| e['message'] }.join(', ')}"
end

data['result'].each do |zone|
  status  = zone['status'] || '-'
  plan    = zone.dig('plan', 'name') || '-'
  puts "#{zone['id']}\t#{zone['name']}\t#{status}\t#{plan}"
end
