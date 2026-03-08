# Redeploy a Vercel deployment
# Usage: ruby scripts/redeploy.rb DEPLOYMENT_ID PROJECT_NAME [--target production]

require_relative 'auth'

deployment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID PROJECT_NAME [--target production]")
project_name  = ARGV[1] or abort("Usage: ruby #{__FILE__} DEPLOYMENT_ID PROJECT_NAME [--target production]")

target = nil
if (idx = ARGV.index('--target')) && ARGV[idx + 1]
  target = ARGV[idx + 1]
end

body = {
  'name'         => project_name,
  'deploymentId' => deployment_id,
}
body['target'] = target if target

data = vercel_request(:post, '/v13/deployments', body: body)

state   = data['readyState'] || data['state'] || '-'
url     = data['url'] || '-'
new_id  = data['id'] || '-'

puts "id:\t#{new_id}"
puts "url:\t#{url}"
puts "state:\t#{state}"
puts "Redeployment triggered for #{project_name}"
