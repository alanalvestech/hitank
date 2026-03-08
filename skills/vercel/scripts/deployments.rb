# List deployments for a Vercel project
# Usage: ruby scripts/deployments.rb PROJECT_ID

require_relative 'auth'

project_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_ID")

data = vercel_request(:get, "/v6/deployments?projectId=#{project_id}&limit=20")

(data['deployments'] || []).each do |d|
  state   = d['state'] || d['readyState'] || '-'
  target  = d['target'] || '-'
  created = d['createdAt'] ? Time.at(d['createdAt'] / 1000).utc.strftime('%Y-%m-%dT%H:%M:%SZ') : '-'
  url     = d['url'] || '-'
  puts "#{d['uid']}\t#{state}\t#{target}\t#{url}\t#{created}"
end
