# List samples
# Usage: ruby scripts/samples.rb APP_ID [--type TYPE] [--action ACTION] [--exception EXCEPTION] [--limit N] [--since TS] [--before TS] [--count_only BOOL]

require_relative 'auth'

app_id = ARGV[0] or abort("Usage: ruby #{__FILE__} APP_ID [options]")

params = {}
type_suffix = ''
if (idx = ARGV.index('--type')) && ARGV[idx + 1]
  t = ARGV[idx + 1]
  type_suffix = "/#{t}" if %w[performance errors].include?(t)
end
if (idx = ARGV.index('--action')) && ARGV[idx + 1]
  params['action_id'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--exception')) && ARGV[idx + 1]
  params['exception'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--limit')) && ARGV[idx + 1]
  params['limit'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--since')) && ARGV[idx + 1]
  params['since'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--before')) && ARGV[idx + 1]
  params['before'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--count_only')) && ARGV[idx + 1]
  params['count_only'] = ARGV[idx + 1]
end

data = appsignal_request(:get, "/#{app_id}/samples#{type_suffix}.json", params: params)

if params['count_only']
  puts "count\t#{data['count']}"
else
  (data || []).each do |s|
    puts "#{s['id']}\t#{s['action']}\t#{s['duration'] || '-'}ms\t#{s['status'] || '-'}\t#{s['is_exception'] ? 'error' : 'ok'}\t#{s['time'] || '-'}"
  end
end
