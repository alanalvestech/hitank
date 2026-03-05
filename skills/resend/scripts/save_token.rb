# Save the Resend API key
# Usage: ruby scripts/save_token.rb API_KEY

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} API_KEY")

# Validate by listing domains
uri = URI('https://api.resend.com/domains')
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Bearer #{token}"
req['Content-Type']  = 'application/json'
req['User-Agent']    = 'hitank-resend/1.0'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid API key: API returned #{resp.code}"
end

token_dir  = File.expand_path('~/.config/resend')
token_file = File.join(token_dir, 'token')

FileUtils.mkdir_p(token_dir)
File.write(token_file, token)
File.chmod(0600, token_file)

puts "Token saved to #{token_file}"
puts "Verified: API key is valid"
