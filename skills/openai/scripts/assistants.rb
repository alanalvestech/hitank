# List OpenAI assistants
# Usage: ruby scripts/assistants.rb

require_relative 'auth'

data = openai_request(:get, '/assistants', headers: { 'OpenAI-Beta' => 'assistants=v2' })

assistants = data['data'] || []
assistants.each do |a|
  name    = a['name'] || '-'
  model   = a['model'] || '-'
  created = a['created_at'] ? Time.at(a['created_at']).strftime('%Y-%m-%d') : '-'
  puts "#{a['id']}\t#{name}\t#{model}\t#{created}"
end
