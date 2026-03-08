# Mute a Datadog monitor
# Usage: ruby scripts/mute_monitor.rb MONITOR_ID

require_relative 'auth'

id = ARGV[0] or abort("Usage: ruby #{__FILE__} MONITOR_ID")

data = dd_request(:post, "/monitor/#{id}/mute")

puts "Monitor #{id} muted"
puts "name=#{data['name']}" if data && data['name']
