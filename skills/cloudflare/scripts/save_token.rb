# Save the Cloudflare API token
# Usage: ruby scripts/save_token.rb TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN")

# Validate by calling the token verify endpoint
uri = URI('https://api.cloudflare.com/client/v4/user/tokens/verify')
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Bearer #{token}"
req['Content-Type']  = 'application/json'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid token: API returned #{resp.code}"
end

data = JSON.parse(resp.body)
unless data['success']
  errors = (data['errors'] || []).map { |e| e['message'] }.join(', ')
  abort "Invalid token: #{errors}"
end

token_dir  = File.expand_path('~/.config/cloudflare')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"

status = data.dig('result', 'status') || 'active'
puts "Verified: token status is #{status}"
