# Create a deploy request for a PlanetScale database
# Usage: ruby scripts/create_deploy_request.rb ORG DATABASE BRANCH [DEPLOY_TO]

require_relative 'auth'

org       = ARGV[0] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH [DEPLOY_TO]")
db        = ARGV[1] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH [DEPLOY_TO]")
branch    = ARGV[2] or abort("Usage: ruby #{__FILE__} ORG DATABASE BRANCH [DEPLOY_TO]")
deploy_to = ARGV[3] || 'main'

body = { branch: branch, into_branch: deploy_to }

data = ps_request(:post, "/organizations/#{org}/databases/#{db}/deploy-requests", body: body)

if data && data['number']
  puts "Deploy request ##{data['number']} created: #{branch} -> #{deploy_to}"
  puts "state:\t#{data['state'] || data['deployment_state']}"
  puts "created_at:\t#{data['created_at']}"
elsif data && data['id']
  puts "Deploy request ##{data['id']} created: #{branch} -> #{deploy_to}"
  puts "created_at:\t#{data['created_at']}"
elsif data && data['message']
  abort "Error: #{data['message']}"
else
  abort "Error: unexpected response"
end
