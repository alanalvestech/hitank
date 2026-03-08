# Get deployment logs for a Vercel deployment
# Usage: ruby scripts/logs.rb DEPLOYMENT_ID

require_relative 'auth'

deployment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID")

data = vercel_request(:get, "/v2/deployments/#{deployment_id}/events")

(data || []).each do |event|
  ts   = event['date'] ? Time.at(event['date'] / 1000).utc.strftime('%Y-%m-%dT%H:%M:%SZ') : '-'
  text = event.dig('payload', 'text') || event['text'] || '-'
  puts "#{ts}\t#{text}"
end
