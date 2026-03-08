# Create a new branch for a PlanetScale database
# Usage: ruby scripts/create_branch.rb ORG DATABASE BRANCH_NAME [PARENT_BRANCH]

require_relative 'auth'

org    = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH_NAME [PARENT_BRANCH]")
db     = ARGV[1] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH_NAME [PARENT_BRANCH]")
branch = ARGV[2] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH_NAME [PARENT_BRANCH]")
parent = ARGV[3] || 'main'

body = { name: branch, parent_branch: parent }

data = ps_request(:post, "/organizations/#{org}/databases/#{db}/branches", body: body)

if data && data['name']
  puts "Branch '#{data['name']}' created from '#{parent}'"
  puts "created_at:\t#{data['created_at']}"
elsif data && data['message']
  abort "Error: #{data['message']}"
else
  abort "Error: unexpected response"
end
