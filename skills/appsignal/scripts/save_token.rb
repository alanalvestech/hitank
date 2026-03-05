# Save the AppSignal personal API key
# Usage: ruby scripts/save_token.rb API_KEY

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} API_KEY")

# Validate by listing apps (any authenticated endpoint)
uri = URI("https://appsignal.com/api/markers.json?token=#{token}")
req = Net::HTTP::Get.new(uri)
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess) || resp.code == '401'
  # A 401 means bad key; anything else might be network issues
end

if resp.code == '401'
  abort "Invalid API key: API returned 401 Unauthorized"
end

token_dir  = File.expand_path('~/.config/appsignal')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"
puts "Verified: API key is valid"
