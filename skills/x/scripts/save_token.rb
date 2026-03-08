# Save Twitter API credentials
# Usage: ruby scripts/save_token.rb API_KEY API_SECRET ACCESS_TOKEN ACCESS_TOKEN_SECRET

require 'json'
require 'net/http'
require 'uri'
require 'fileutils'
require 'openssl'
require 'base64'
require 'securerandom'

if ARGV.length < 4
  abort "Usage: ruby #{__FILE__} API_KEY API_SECRET ACCESS_TOKEN ACCESS_TOKEN_SECRET"
end

api_key        = ARGV[0]
api_secret     = ARGV[1]
access_token   = ARGV[2]
access_secret  = ARGV[3]

# --- OAuth 1.0a signature for validation request ---

def percent_encode(str)
  URI.encode_www_form_component(str.to_s).gsub('+', '%20')
end

url = 'https://api.twitter.com/2/users/me'

oauth_params = {
  'oauth_consumer_key'     => api_key,
  'oauth_token'            => access_token,
  'oauth_signature_method' => 'HMAC-SHA1',
  'oauth_timestamp'        => Time.now.to_i.to_s,
  'oauth_nonce'            => SecureRandom.hex(16),
  'oauth_version'          => '1.0'
}

param_string = oauth_params
  .sort_by { |k, _| k }
  .map { |k, v| "#{percent_encode(k)}=#{percent_encode(v)}" }
  .join('&')

base_string = [
  'GET',
  percent_encode(url),
  percent_encode(param_string)
].join('&')

signing_key = "#{percent_encode(api_secret)}&#{percent_encode(access_secret)}"
digest      = OpenSSL::Digest.new('sha1')
signature   = Base64.strict_encode64(OpenSSL::HMAC.digest(digest, signing_key, base_string))

oauth_params['oauth_signature'] = signature

header_parts = oauth_params
  .sort_by { |k, _| k }
  .map { |k, v| "#{percent_encode(k)}=\"#{percent_encode(v)}\"" }
  .join(', ')

auth_header = "OAuth #{header_parts}"

# Validate credentials
uri = URI(url)
req = Net::HTTP::Get.new(uri)
req['Authorization'] = auth_header
req['User-Agent']    = 'hitank-twitter-skill/1.0'

resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

unless resp.is_a?(Net::HTTPSuccess)
  abort "Invalid credentials: API returned #{resp.code} — #{resp.body}"
end

# Save all 4 credential files
config_dir = File.expand_path('~/.config/x')
FileUtils.mkdir_p(config_dir)

{ 'api_key' => api_key, 'api_secret' => api_secret,
  'access_token' => access_token, 'access_token_secret' => access_secret }.each do |name, value|
  path = File.join(config_dir, name)
  File.write(path, value)
  File.chmod(0600, path)
end

puts "Credentials saved to #{config_dir}"

account = JSON.parse(resp.body)
username = account.dig('data', 'username')
puts "Verified: logged in as @#{username}"
