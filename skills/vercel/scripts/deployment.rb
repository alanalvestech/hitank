# Get details for a Vercel deployment
# Usage: ruby scripts/deployment.rb DEPLOYMENT_ID

require_relative 'auth'

deployment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID")

data = vercel_request(:get, "/v13/deployments/#{deployment_id}")

state      = data['readyState'] || data['state'] || '-'
target     = data['target'] || '-'
url        = data['url'] || '-'
created    = data['createdAt'] ? Time.at(data['createdAt'] / 1000).utc.strftime('%Y-%m-%dT%H:%M:%SZ') : '-'
ready      = data['ready'] ? Time.at(data['ready'] / 1000).utc.strftime('%Y-%m-%dT%H:%M:%SZ') : '-'
branch     = data.dig('gitSource', 'ref') || '-'
commit_sha = data.dig('gitSource', 'sha') || '-'
commit_msg = data.dig('meta', 'githubCommitMessage') || '-'

puts "id:\t#{data['id']}"
puts "url:\t#{url}"
puts "state:\t#{state}"
puts "target:\t#{target}"
puts "branch:\t#{branch}"
puts "commit_sha:\t#{commit_sha}"
puts "commit_message:\t#{commit_msg}"
puts "created_at:\t#{created}"
puts "ready_at:\t#{ready}"
