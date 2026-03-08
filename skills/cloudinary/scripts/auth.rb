# Cloudinary REST API — Auth via Basic (api_key:api_secret)
# Usage: require this file at the beginning of any skill script.
# Provides: cloudinary_request(method, path, body:) helper

require 'json'
require 'net/http'
require 'uri'

CONFIG_DIR       = File.expand_path('~/.config/cloudinary')
CLOUD_NAME_FILE  = File.join(CONFIG_DIR, 'cloud_name')
API_KEY_FILE     = File.join(CONFIG_DIR, 'api_key')
API_SECRET_FILE  = File.join(CONFIG_DIR, 'api_secret')

[CLOUD_NAME_FILE, API_KEY_FILE, API_SECRET_FILE].each do |f|
  unless File.exist?(f)
    abort <<~MSG
      Cloudinary config not found at #{f}
      Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
    MSG
  end
end

CLOUD_NAME = File.read(CLOUD_NAME_FILE).strip
API_KEY    = File.read(API_KEY_FILE).strip
API_SECRET = File.read(API_SECRET_FILE).strip
BASE_URL   = "https://api.cloudinary.com/v1_1/#{CLOUD_NAME}"

def cloudinary_request(method, path, body: nil)
  uri = URI("#{BASE_URL}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :patch  then Net::HTTP::Patch.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req.basic_auth(API_KEY, API_SECRET)
  if body
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
