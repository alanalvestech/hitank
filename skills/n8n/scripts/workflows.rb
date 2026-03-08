# List all n8n workflows
# Usage: ruby scripts/workflows.rb

require_relative 'auth'

data = n8n_request(:get, '/api/v1/workflows')
workflows = data['data'] || []

if workflows.empty?
  puts "No workflows found"
  exit 0
end

workflows.each do |wf|
  active  = wf['active'] ? 'active' : 'inactive'
  updated = wf['updatedAt'] || '-'
  puts "#{wf['id']}\t#{wf['name']}\t#{active}\t#{updated}"
end
