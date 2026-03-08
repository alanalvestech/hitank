# Save the PlanetScale service token credentials
# Usage: ruby scripts/save_token.rb TOKEN_ID TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token_id = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN_ID TOKEN")
token    = ARGV[1] or abort("Usage: ruby #{__FILE__} TOKEN_ID TOKEN")

# Validate by calling the API
uri = URI('https://api.planetscale.com/v1/organizations')
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "#{token_id}:#{token}"
req['Content-Type']  = 'application/json'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid credentials: API returned #{resp.code}"
end

config_dir = File.expand_path('~/.config/planetscale')
FileUtils.mkdir_p(config_dir)

token_id_file = File.join(config_dir, 'token_id')
token_file    = File.join(config_dir, 'token')

File.write(token_id_file, token_id)
File.chmod(0600, token_id_file)

File.write(token_file, token)
File.chmod(0600, token_file)

puts "Credentials saved to #{config_dir}"

orgs = JSON.parse(resp.body)
data = orgs['data'] || orgs
if data.is_a?(Array) && data.any?
  names = data.map { |o| o['name'] }.compact.join(', ')
  puts "Verified: access to organizations: #{names}"
else
  puts "Verified: credentials accepted"
end
