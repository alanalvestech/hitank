# Get details for an OpenAI assistant
# Usage: ruby scripts/assistant.rb ASSISTANT_ID

require_relative 'auth'

assistant_id = ARGV[0] or abort("Usage: ruby #{__FILE__} ASSISTANT_ID")

data = openai_request(:get, "/assistants/#{assistant_id}", headers: { 'OpenAI-Beta' => 'assistants=v2' })

name         = data['name'] || '-'
model        = data['model'] || '-'
instructions = data['instructions'] || '-'
created      = data['created_at'] ? Time.at(data['created_at']).strftime('%Y-%m-%d %H:%M:%S') : '-'
tools        = (data['tools'] || []).map { |t| t['type'] }.join(', ')
tools        = '-' if tools.empty?

puts "id:\t#{data['id']}"
puts "name:\t#{name}"
puts "model:\t#{model}"
puts "tools:\t#{tools}"
puts "created_at:\t#{created}"
puts "instructions:\t#{instructions}"
