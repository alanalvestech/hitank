# Twilio REST API — Auth via Basic Auth (Account SID + Auth Token)
# Usage: require this file at the beginning of any skill script.
# Provides: twilio_request(method, path, form_data:) helper
# Also provides: ACCOUNT_SID constant for building paths

require 'json'
require 'net/http'
require 'uri'

TOKEN_FILE = File.expand_path('~/.config/twilio/credentials')
BASE_URL   = 'https://api.twilio.com/2010-04-01'

unless File.exist?(TOKEN_FILE)
  abort <<~MSG
    Twilio credentials not found at #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

creds = File.read(TOKEN_FILE).strip
parts = creds.split(':', 2)
if parts.length != 2 || parts.any? { |p| p.empty? }
  abort "Invalid credentials format in #{TOKEN_FILE}. Expected account_sid:auth_token"
end

ACCOUNT_SID = parts[0]
AUTH_TOKEN   = parts[1]

def twilio_request(method, path, form_data: nil)
  uri = URI("#{BASE_URL}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req.basic_auth(ACCOUNT_SID, AUTH_TOKEN)
  if form_data
    req.set_form_data(form_data)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
