# Save the n8n API key and host URL
# Usage: ruby scripts/save_token.rb API_KEY HOST

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

api_key = ARGV[0] or abort("Usage: ruby #{__FILE__} API_KEY HOST")
host    = ARGV[1] or abort("Usage: ruby #{__FILE__} API_KEY HOST")

# Strip trailing slash from host
host = host.chomp('/')

# Validate by calling the API
uri = URI("#{host}/api/v1/workflows?limit=1")
req = Net::HTTP::Get.new(uri)
req['X-N8N-API-KEY'] = api_key
req['Accept']        = 'application/json'

use_ssl = uri.scheme == 'https'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid API key or host: API returned #{resp.code}"
end

config_dir = File.expand_path('~/.config/n8n')
FileUtils.mkdir_p(config_dir)

api_key_file = File.join(config_dir, 'api_key')
host_file    = File.join(config_dir, 'host')

File.write(api_key_file, api_key)
File.chmod(0600, api_key_file)

File.write(host_file, host)
File.chmod(0600, host_file)

puts "API key saved to #{api_key_file}"
puts "Host saved to #{host_file}"

data = JSON.parse(resp.body)
count = data['data']&.length || 0
puts "Verified: connected to #{host} (#{count} workflow(s) found)"
