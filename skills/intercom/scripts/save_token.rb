# Save the Intercom API token
# Usage: ruby scripts/save_token.rb TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN")

# Validate by calling the API
uri = URI('https://api.intercom.io/me')
req = Net::HTTP::Get.new(uri)
req['Authorization']    = "Bearer #{token}"
req['Accept']           = 'application/json'
req['Content-Type']     = 'application/json'
req['Intercom-Version'] = '2.11'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid token: API returned #{resp.code}"
end

token_dir  = File.expand_path('~/.config/intercom')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"

admin = JSON.parse(resp.body)
puts "Verified: logged in as #{admin['name']} (#{admin['email']})"
