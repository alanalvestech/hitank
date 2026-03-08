# List available OpenAI models
# Usage: ruby scripts/models.rb

require_relative 'auth'

data = openai_request(:get, '/models')

models = data['data'] || []
models.sort_by { |m| m['id'] }.each do |model|
  owner   = model['owned_by'] || '-'
  created = model['created'] ? Time.at(model['created']).strftime('%Y-%m-%d') : '-'
  puts "#{model['id']}\t#{owner}\t#{created}"
end
