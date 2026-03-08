# Save Zendesk credentials (subdomain, email, API token)
# Usage: ruby scripts/save_token.rb SUBDOMAIN EMAIL API_TOKEN

require 'json'
require 'net/http'
require 'uri'
require 'base64'
require 'fileutils'

subdomain = ARGV[0] or abort("Usage: ruby #{__FILE__} SUBDOMAIN EMAIL API_TOKEN")
email     = ARGV[1] or abort("Usage: ruby #{__FILE__} SUBDOMAIN EMAIL API_TOKEN")
api_token = ARGV[2] or abort("Usage: ruby #{__FILE__} SUBDOMAIN EMAIL API_TOKEN")

# Validate by calling the API
uri = URI("https://#{subdomain}.zendesk.com/api/v2/users/me")
req = Net::HTTP::Get.new(uri)
credentials = Base64.strict_encode64("#{email}/token:#{api_token}")
req['Authorization'] = "Basic #{credentials}"
req['Content-Type']  = 'application/json'
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid credentials: API returned #{resp.code}"
end

config_dir = File.expand_path('~/.config/zendesk')
FileUtils.mkdir_p(config_dir)

{ 'subdomain' => subdomain, 'email' => email, 'token' => api_token }.each do |name, value|
  path = File.join(config_dir, name)
  File.write(path, value)
  File.chmod(0600, path)
end

puts "Credentials saved to #{config_dir}"

user = JSON.parse(resp.body)['user']
puts "Verified: logged in as #{user['name']} (#{user['email']})"
