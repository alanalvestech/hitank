# Update a marker
# Usage: ruby scripts/update_marker.rb APP_ID MARKER_ID [--repository REPO] [--revision REV] [--user USER] [--icon ICON] [--message MSG]

require_relative 'auth'

app_id    = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_ID MARKER_ID [options]")
marker_id = ARGV[1] or abort("Usage: ruby #{__FILE__} APP_ID MARKER_ID [options]")

marker = {}
if (idx = ARGV.index('--repository')) && ARGV[idx + 1]
  marker['repository'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--revision')) && ARGV[idx + 1]
  marker['revision'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--user')) && ARGV[idx + 1]
  marker['user'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--icon')) && ARGV[idx + 1]
  marker['icon'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--message')) && ARGV[idx + 1]
  marker['message'] = ARGV[idx + 1]
end

data = appsignal_request(:put, "/#{app_id}/markers/#{marker_id}.json", body: { 'marker' => marker })

if data
  data.each { |k, v| puts "#{k}\t#{v}" }
else
  puts "Marker updated"
end
