# List API keys
# Usage: ruby scripts/api_keys.rb

require_relative 'auth'

data = resend_request(:get, '/api-keys')

(data['data'] || []).each do |k|
  puts "#{k['id']}\t#{k['name'] || '-'}\t#{k['created_at'] || '-'}"
end
