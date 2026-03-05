# Get marker details
# Usage: ruby scripts/marker.rb APP_ID MARKER_ID

require_relative 'auth'

app_id    = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_ID MARKER_ID")
marker_id = ARGV[1] or abort("Usage: ruby #{__FILE__} APP_ID MARKER_ID")

data = appsignal_request(:get, "/#{app_id}/markers/#{marker_id}.json")

data.each do |k, v|
  puts "#{k}\t#{v}"
end
