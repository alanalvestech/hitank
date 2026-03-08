# List n8n credentials (no secrets shown)
# Usage: ruby scripts/credentials.rb

require_relative 'auth'

data = n8n_request(:get, '/api/v1/credentials')
credentials = data['data'] || []

if credentials.empty?
  puts "No credentials found"
  exit 0
end

credentials.each do |cred|
  created = cred['createdAt'] || '-'
  puts "#{cred['id']}\t#{cred['name']}\t#{cred['type']}\t#{created}"
end
