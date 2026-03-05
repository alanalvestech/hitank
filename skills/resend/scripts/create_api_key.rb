# Create an API key
# Usage: ruby scripts/create_api_key.rb NAME [--permission PERMISSION] [--domain-id DOMAIN_ID]
# Permissions: full-access (default), sending-access

require_relative 'auth'

name = ARGV[0] or abort("Usage: ruby #{__FILE__} NAME [--permission PERMISSION] [--domain-id DOMAIN_ID]")

body = { 'name' => name }

if (idx = ARGV.index('--permission')) && ARGV[idx + 1]
  body['permission'] = ARGV[idx + 1]
end
if (idx = ARGV.index('--domain-id')) && ARGV[idx + 1]
  body['domain_id'] = ARGV[idx + 1]
end

data = resend_request(:post, '/api-keys', body: body)

puts "id:\t#{data['id']}"
puts "token:\t#{data['token']}" if data['token']
puts "IMPORTANT: Save this token now. It won't be shown again."
