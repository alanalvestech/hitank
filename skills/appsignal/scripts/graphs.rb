# Get graph data
# Usage: ruby scripts/graphs.rb APP_ID [--kind KIND] [--action ACTION] [--timeframe TIMEFRAME] [--fields FIELDS] [--from FROM] [--to TO]

require_relative 'auth'

app_id = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_ID [options]")

params = {}
if (idx = ARGV.index('--kind')) && ARGV[idx + 1]
  params['kind'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--action')) && ARGV[idx + 1]
  params['action_name'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--timeframe')) && ARGV[idx + 1]
  params['timeframe'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--from')) && ARGV[idx + 1]
  params['from'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--to')) && ARGV[idx + 1]
  params['to'] = ARGV[idx + 1]
end

# fields[] needs special handling
fields = []
if (idx = ARGV.index('--fields')) && ARGV[idx + 1]
  fields = ARGV[idx + 1].split(',')
end

# Build query string manually for fields[] array params
query_parts = params.map { |k, v| "#{k}=#{URI.encode_www_form_component(v)}" }
fields.each { |f| query_parts << "fields[]=#{URI.encode_www_form_component(f)}" }

# Use raw request to handle array params
uri = URI("#{BASE_URL}/#{app_id}/graphs.json")
all_params = params.merge('token' => APPSIGNAL_TOKEN)
query = all_params.map { |k, v| "#{k}=#{URI.encode_www_form_component(v)}" }
fields.each { |f| query << "fields[]=#{URI.encode_www_form_component(f)}" }
uri.query = query.join('&')

req = Net::HTTP::Get.new(uri)
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
data = JSON.parse(resp.body)

puts "from\t#{data['from']}"
puts "to\t#{data['to']}"
puts "resolution\t#{data['resolution']}"
(data['data'] || []).each do |point|
  cols = [point['timestamp']]
  fields.each { |f| cols << (point[f] || '-') }
  puts cols.join("\t")
end
