# List n8n executions
# Usage: ruby scripts/executions.rb [--workflowId ID] [--status STATUS]
# Status values: error, success, waiting

require_relative 'auth'

params = []
i = 0
while i < ARGV.length
  case ARGV[i]
  when '--workflowId'
    params << "workflowId=#{ARGV[i + 1]}"
    i += 2
  when '--status'
    params << "status=#{ARGV[i + 1]}"
    i += 2
  else
    i += 1
  end
end

query = params.empty? ? '' : "?#{params.join('&')}"
data = n8n_request(:get, "/api/v1/executions#{query}")
executions = data['data'] || []

if executions.empty?
  puts "No executions found"
  exit 0
end

executions.each do |ex|
  status   = ex['status'] || ex['finished'] ? 'finished' : 'running'
  wf_name  = ex.dig('workflowData', 'name') || '-'
  started  = ex['startedAt'] || '-'
  puts "#{ex['id']}\t#{wf_name}\t#{status}\t#{started}"
end
