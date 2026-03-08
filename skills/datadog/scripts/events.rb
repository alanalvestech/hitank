# List Datadog events
# Usage: ruby scripts/events.rb [--hours N]

require_relative 'auth'

hours = 24
if idx = ARGV.index('--hours')
  hours = (ARGV[idx + 1] || 24).to_i
end

now   = Time.now.to_i
start = now - (hours * 3600)

data = dd_request(:get, '/events', params: { start: start, end: now })

events = data['events'] || []
events.each do |e|
  title   = e['title'] || '-'
  source  = e['source'] || '-'
  date_ts = e['date_happened']
  date    = date_ts ? Time.at(date_ts).strftime('%Y-%m-%d %H:%M:%S') : '-'
  priority = e['priority'] || '-'
  puts "#{e['id']}\t#{title}\t#{source}\t#{priority}\t#{date}"
end
