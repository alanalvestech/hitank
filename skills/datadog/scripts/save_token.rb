# Save the Datadog API key and Application key
# Usage: ruby scripts/save_token.rb API_KEY APP_KEY

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

api_key = ARGV[0] or abort("Usage: ruby #{__FILE__} API_KEY APP_KEY")
app_key = ARGV[1] or abort("Usage: ruby #{__FILE__} API_KEY APP_KEY")

# Validate by calling the API
uri = URI('https://api.datadoghq.com/api/v1/validate')
req = Net::HTTP::Get.new(uri)
req['DD-API-KEY']         = api_key
req['DD-APPLICATION-KEY'] = app_key
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid keys: API returned #{resp.code}"
end

config_dir = File.expand_path('~/.config/datadog')
FileUtils.mkdir_p(config_dir)

api_key_file = File.join(config_dir, 'api_key')
app_key_file = File.join(config_dir, 'app_key')

File.write(api_key_file, api_key)
File.chmod(0600, api_key_file)

File.write(app_key_file, app_key)
File.chmod(0600, app_key_file)

puts "API key saved to #{api_key_file}"
puts "Application key saved to #{app_key_file}"

data = JSON.parse(resp.body)
puts "Verified: API key is valid"
