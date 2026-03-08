# Zendesk REST API — Auth via Basic Authentication ({email}/token:{api_token})
# Usage: require this file at the beginning of any skill script.
# Provides: zendesk_request(method, path, body:) helper

require 'json'
require 'net/http'
require 'uri'
require 'base64'

CONFIG_DIR     = File.expand_path('~/.config/zendesk')
TOKEN_FILE     = File.join(CONFIG_DIR, 'token')
SUBDOMAIN_FILE = File.join(CONFIG_DIR, 'subdomain')
EMAIL_FILE     = File.join(CONFIG_DIR, 'email')

[TOKEN_FILE, SUBDOMAIN_FILE, EMAIL_FILE].each do |f|
  unless File.exist?(f)
    abort <<~MSG
      Zendesk config not found at #{f}
      Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
    MSG
  end
end

ZENDESK_TOKEN     = File.read(TOKEN_FILE).strip
ZENDESK_SUBDOMAIN = File.read(SUBDOMAIN_FILE).strip
ZENDESK_EMAIL     = File.read(EMAIL_FILE).strip
BASE_URL          = "https://#{ZENDESK_SUBDOMAIN}.zendesk.com/api/v2"

CREDENTIALS = Base64.strict_encode64("#{ZENDESK_EMAIL}/token:#{ZENDESK_TOKEN}")

def zendesk_request(method, path, body: nil)
  uri = URI("#{BASE_URL}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :patch  then Net::HTTP::Patch.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['Authorization'] = "Basic #{CREDENTIALS}"
  req['Content-Type']  = 'application/json'
  if body
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
