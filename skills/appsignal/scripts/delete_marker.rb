# Delete a marker
# Usage: ruby scripts/delete_marker.rb APP_ID MARKER_ID

require_relative 'auth'

app_id    = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_ID MARKER_ID")
marker_id = ARGV[1] or abort("Usage: ruby #{__FILE__} APP_ID MARKER_ID")

appsignal_request(:delete, "/#{app_id}/markers/#{marker_id}.json")

puts "Marker #{marker_id} deleted"
