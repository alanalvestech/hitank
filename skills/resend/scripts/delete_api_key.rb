# Delete an API key
# Usage: ruby scripts/delete_api_key.rb API_KEY_ID

require_relative 'auth'

api_key_id = ARGV[0] or abort("Usage: ruby #{__FILE__} API_KEY_ID")

resend_request(:delete, "/api-keys/#{api_key_id}")

puts "Deleted API key: #{api_key_id}"
