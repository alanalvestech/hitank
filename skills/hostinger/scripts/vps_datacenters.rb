# List available VPS data centers
# Usage: ruby scripts/vps_datacenters.rb

require_relative 'auth'

data = hostinger_request(:get, '/api/vps/v1/data-centers')

(data || []).each do |dc|
  puts "#{dc['id']}\t#{dc['name'] || '-'}\t#{dc['location'] || '-'}"
end
