# Datadog API — Auth via API Key + Application Key
# Usage: require this file at the beginning of any skill script.
# Provides: dd_request(method, path, body:, params:) helper

require 'json'
require 'net/http'
require 'uri'

TOKEN_FILE  = File.expand_path('~/.config/datadog/api_key')
APP_KEY_FILE = File.expand_path('~/.config/datadog/app_key')
BASE_URL    = 'https://api.datadoghq.com/api/v1'

unless File.exist?(TOKEN_FILE)
  abort <<~MSG
    Datadog API key not found at #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

unless File.exist?(APP_KEY_FILE)
  abort <<~MSG
    Datadog Application key not found at #{APP_KEY_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

DD_API_KEY = File.read(TOKEN_FILE).strip
DD_APP_KEY = File.read(APP_KEY_FILE).strip

def dd_request(method, path, body: nil, params: {})
  uri = URI("#{BASE_URL}#{path}")
  uri.query = URI.encode_www_form(params) unless params.empty?
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :patch  then Net::HTTP::Patch.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['DD-API-KEY']         = DD_API_KEY
  req['DD-APPLICATION-KEY'] = DD_APP_KEY
  req['Content-Type']       = 'application/json'
  if body
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
