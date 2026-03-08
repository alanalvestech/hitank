# Save the PostHog API token and host
# Usage: ruby scripts/save_token.rb TOKEN [HOST]
# HOST defaults to https://app.posthog.com

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

token = ARGV[0] or abort("Usage: ruby #{__FILE__} TOKEN [HOST]")
host  = ARGV[1] || 'https://app.posthog.com'
host  = host.chomp('/')

# Validate by calling the API
uri = URI("#{host}/api/projects/")
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Bearer #{token}"
req['Content-Type']  = 'application/json'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid token: API returned #{resp.code}"
end

config_dir = File.expand_path('~/.config/posthog')
FileUtils.mkdir_p(config_dir)

token_file = File.join(config_dir, 'token')
File.write(token_file, token)
File.chmod(0600, token_file)

host_file = File.join(config_dir, 'host')
File.write(host_file, host)
File.chmod(0600, host_file)

puts "Token saved to #{token_file}"
puts "Host saved to #{host_file} (#{host})"

data = JSON.parse(resp.body)
results = data['results'] || data
count = results.is_a?(Array) ? results.length : 0
puts "Verified: token valid, #{count} project(s) accessible"
