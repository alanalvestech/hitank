# Get details for a Vercel project
# Usage: ruby scripts/project.rb PROJECT_NAME_OR_ID

require_relative 'auth'

project = ARGV[0] or abort("Usage: ruby #{__FILE__} PROJECT_NAME_OR_ID")

data = vercel_request(:get, "/v9/projects/#{project}")

framework   = data['framework'] || '-'
node_ver    = data['nodeVersion'] || '-'
created     = data['createdAt'] ? Time.at(data['createdAt'] / 1000).utc.strftime('%Y-%m-%dT%H:%M:%SZ') : '-'
updated     = data['updatedAt'] ? Time.at(data['updatedAt'] / 1000).utc.strftime('%Y-%m-%dT%H:%M:%SZ') : '-'
repo        = data.dig('link', 'repo') || '-'
repo_type   = data.dig('link', 'type') || '-'

puts "name:\t#{data['name']}"
puts "id:\t#{data['id']}"
puts "framework:\t#{framework}"
puts "node_version:\t#{node_ver}"
puts "repo:\t#{repo}"
puts "repo_type:\t#{repo_type}"
puts "created_at:\t#{created}"
puts "updated_at:\t#{updated}"
