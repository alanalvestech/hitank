# Unmute a Datadog monitor
# Usage: ruby scripts/unmute_monitor.rb MONITOR_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} MONITOR_ID")

data = dd_request(:post, "/monitor/#{id}/unmute")

puts "Monitor #{id} unmuted"
puts "name=#{data['name']}" if data && data['name']
