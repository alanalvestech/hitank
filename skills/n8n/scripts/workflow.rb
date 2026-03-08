# Get details for an n8n workflow
# Usage: ruby scripts/workflow.rb WORKFLOW_ID

require_relative 'auth'

wf_id = ARGV[0] or abort("Usage: ruby #{__FILE__} WORKFLOW_ID")

data = n8n_request(:get, "/api/v1/workflows/#{wf_id}")

active  = data['active'] ? 'active' : 'inactive'
created = data['createdAt'] || '-'
updated = data['updatedAt'] || '-'
nodes   = data['nodes'] || []
node_names = nodes.map { |n| n['name'] || n['type'] }.join(', ')

puts "id:\t#{data['id']}"
puts "name:\t#{data['name']}"
puts "active:\t#{active}"
puts "createdAt:\t#{created}"
puts "updatedAt:\t#{updated}"
puts "nodes:\t#{nodes.length} (#{node_names})"
puts "tags:\t#{(data['tags'] || []).map { |t| t['name'] }.join(', ')}"
