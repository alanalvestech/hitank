# AppSignal API — Auth via query-param token
# Usage: require this file at the beginning of any skill script.
# Provides: appsignal_request(method, path, body:, params:) helper

require 'json'
require 'net/http'
require 'uri'

TOKEN_FILE = File.expand_path('~/.config/appsignal/token')
BASE_URL   = 'https://appsignal.com/api'

unless File.exist?(TOKEN_FILE)
  abort <<~MSG
    AppSignal token not found at #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

APPSIGNAL_TOKEN = File.read(TOKEN_FILE).strip

def appsignal_request(method, path, body: nil, params: {})
  params['token'] = APPSIGNAL_TOKEN
  uri = URI("#{BASE_URL}#{path}")
  uri.query = URI.encode_www_form(params) unless params.empty?
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  if body
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
