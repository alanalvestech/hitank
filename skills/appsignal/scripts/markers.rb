# List markers
# Usage: ruby scripts/markers.rb APP_ID [--limit N] [--kind KIND] [--from FROM] [--to TO] [--count_only BOOL]

require_relative 'auth'

app_id = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_ID [options]")

params = {}
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--kind')) && ARGV[idx + 1]
  params['kind'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--from')) && ARGV[idx + 1]
  params['from'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--to')) && ARGV[idx + 1]
  params['to'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--count_only')) && ARGV[idx + 1]
  params['count_only'] = ARGV[idx + 1]
end

data = appsignal_request(:get, "/#{app_id}/markers.json", params: params)

if data['count_only'] || params['count_only']
  puts "count\t#{data['count']}"
else
  puts "count\t#{data['count']}"
  (data['markers'] || []).each do |m|
    puts "#{m['id']}\t#{m['kind']}\t#{m['created_at']}\t#{m['user'] || m['message'] || '-'}\t#{m['revision'] || m['icon'] || '-'}"
  end
end
