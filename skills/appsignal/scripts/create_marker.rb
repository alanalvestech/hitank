# Create a marker (deploy or custom)
# Usage: ruby scripts/create_marker.rb APP_ID --kind KIND [--repository REPO] [--revision REV] [--user USER] [--icon ICON] [--message MSG]

require_relative 'auth'

app_id = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_ID --kind deploy|custom [options]")

marker = {}
if (idx = ARGV.index('--kind')) && ARGV[idx + 1]
  marker['kind'] = ARGV[idx + 1]
end
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

abort("--kind is required (deploy or custom)") unless marker['kind']

data = appsignal_request(:post, "/#{app_id}/markers.json", body: { 'marker' => marker })

if data
  data.each { |k, v| puts "#{k}\t#{v}" }
else
  puts "Marker created"
end
