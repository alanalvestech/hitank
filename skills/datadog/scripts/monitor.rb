# Get Datadog monitor details
# Usage: ruby scripts/monitor.rb MONITOR_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} MONITOR_ID")

m = dd_request(:get, "/monitor/#{id}")

puts "id=#{m['id']}"
puts "name=#{m['name']}"
puts "type=#{m['type']}"
puts "status=#{m['overall_state']}"
puts "query=#{m['query']}"
puts "message=#{m['message']}"
puts "created=#{m['created']}"
puts "modified=#{m['modified']}"
puts "creator=#{m.dig('creator', 'email') || '-'}"
puts "muted=#{m.dig('options', 'silenced') ? 'true' : 'false'}"
tags = (m['tags'] || []).join(', ')
puts "tags=#{tags}"
