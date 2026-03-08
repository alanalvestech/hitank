# Save Cloudinary credentials (cloud name, API key, API secret)
# Usage: ruby scripts/save_token.rb CLOUD_NAME API_KEY API_SECRET

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'

cloud_name = ARGV[0] or abort("Usage: ruby #{__FILE__} CLOUD_NAME API_KEY API_SECRET")
api_key    = ARGV[1] or abort("Usage: ruby #{__FILE__} CLOUD_NAME API_KEY API_SECRET")
api_secret = ARGV[2] or abort("Usage: ruby #{__FILE__} CLOUD_NAME API_KEY API_SECRET")

# Validate by calling the API
uri = URI("https://api.cloudinary.com/v1_1/#{cloud_name}/resources/image")
req = Net::HTTP::Get.new(uri)
req.basic_auth(api_key, api_secret)
resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid credentials: API returned #{resp.code}"
end

config_dir = File.expand_path('~/.config/cloudinary')
FileUtils.mkdir_p(config_dir)

{ 'cloud_name' => cloud_name, 'api_key' => api_key, 'api_secret' => api_secret }.each do |name, value|
  path = File.join(config_dir, name)
  File.write(path, value)
  File.chmod(0600, path)
end

puts "Credentials saved to #{config_dir}"

data = JSON.parse(resp.body)
count = data['resources']&.length || 0
puts "Verified: connected to cloud '#{cloud_name}' (#{count} images found)"
