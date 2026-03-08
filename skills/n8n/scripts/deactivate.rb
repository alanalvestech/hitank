# Deactivate an n8n workflow
# Usage: ruby scripts/deactivate.rb WORKFLOW_ID

require_relative 'auth'

wf_id = ARGV[0] or abort("Usage: ruby #{__FILE__} WORKFLOW_ID")

data = n8n_request(:post, "/api/v1/workflows/#{wf_id}/deactivate")

puts "Workflow #{data['id']} (#{data['name']}) is now inactive"
