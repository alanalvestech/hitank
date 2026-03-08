# Save the Sentry API token
# Usage: ruby scripts/save_token.rb TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN")

# Validate by calling the API
uri = URI('https://sentry.io/api/0/auth/')
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Bearer #{token}"
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid token: API returned #{resp.code}"
end

token_dir  = File.expand_path('~/.config/sentry')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"

auth = JSON.parse(resp.body)
user = auth.dig('user', 'username') || auth.dig('user', 'email') || 'unknown'
puts "Verified: logged in as #{user}"
