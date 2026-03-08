# PlanetScale REST API — Auth via Service Token
# Usage: require this file at the beginning of any skill script.
# Provides: ps_request(method, path, body:) helper

require 'json'
require 'net/http'
require 'uri'

TOKEN_ID_FILE = File.expand_path('~/.config/planetscale/token_id')
TOKEN_FILE    = File.expand_path('~/.config/planetscale/token')
BASE_URL      = 'https://api.planetscale.com/v1'

unless File.exist?(TOKEN_ID_FILE) && File.exist?(TOKEN_FILE)
  abort <<~MSG
    PlanetScale credentials not found at #{TOKEN_ID_FILE} and #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

PS_TOKEN_ID = File.read(TOKEN_ID_FILE).strip
PS_TOKEN    = File.read(TOKEN_FILE).strip

def ps_request(method, path, body: nil)
  uri = URI("#{BASE_URL}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :patch  then Net::HTTP::Patch.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['Authorization'] = "#{PS_TOKEN_ID}:#{PS_TOKEN}"
  req['Content-Type']  = 'application/json'
  if body
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
