# Get details for an n8n execution
# Usage: ruby scripts/execution.rb EXECUTION_ID

require_relative 'auth'

exec_id = ARGV[0] or abort("Usage: ruby #{__FILE__} EXECUTION_ID")

data = n8n_request(:get, "/api/v1/executions/#{exec_id}")

status   = data['status'] || (data['finished'] ? 'finished' : 'running')
wf_name  = data.dig('workflowData', 'name') || '-'
started  = data['startedAt'] || '-'
finished = data['stoppedAt'] || '-'
mode     = data['mode'] || '-'

puts "id:\t#{data['id']}"
puts "workflow:\t#{wf_name}"
puts "status:\t#{status}"
puts "mode:\t#{mode}"
puts "startedAt:\t#{started}"
puts "stoppedAt:\t#{finished}"

if data['data'] && data['data']['resultData'] && data['data']['resultData']['error']
  error = data['data']['resultData']['error']
  puts "error:\t#{error['message'] || error}"
end
