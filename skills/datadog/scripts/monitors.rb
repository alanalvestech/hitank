# List all Datadog monitors
# Usage: ruby scripts/monitors.rb

require_relative 'auth'

data = dd_request(:get, '/monitor')

data.each do |m|
  status  = m['overall_state'] || '-'
  type    = m['type'] || '-'
  name    = m['name'] || '-'
  puts "#{m['id']}\t#{name}\t#{type}\t#{status}"
end
