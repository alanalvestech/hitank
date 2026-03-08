# List Datadog infrastructure hosts
# Usage: ruby scripts/hosts.rb

require_relative 'auth'

data = dd_request(:get, '/hosts')

hosts = data['host_list'] || []
hosts.each do |h|
  name     = h['name'] || '-'
  up       = h['is_muted'] ? 'muted' : 'active'
  apps     = (h['apps'] || []).join(', ')
  platform = h.dig('meta', 'platform') || '-'
  last_reported = h['last_reported_time']
  reported = last_reported ? Time.at(last_reported).strftime('%Y-%m-%d %H:%M:%S') : '-'
  puts "#{name}\t#{up}\t#{platform}\t#{apps}\t#{reported}"
end
