# n8n REST API — Auth via X-N8N-API-KEY header
# Usage: require this file at the beginning of any skill script.
# Provides: n8n_request(method, path, body:) helper

require 'json'
require 'net/http'
require 'uri'

API_KEY_FILE = File.expand_path('~/.config/n8n/api_key')
HOST_FILE    = File.expand_path('~/.config/n8n/host')

unless File.exist?(API_KEY_FILE)
  abort <<~MSG
    n8n API key not found at #{API_KEY_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

unless File.exist?(HOST_FILE)
  abort <<~MSG
    n8n host not found at #{HOST_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

N8N_API_KEY = File.read(API_KEY_FILE).strip
N8N_HOST    = File.read(HOST_FILE).strip

def n8n_request(method, path, body: nil)
  uri = URI("#{N8N_HOST}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :patch  then Net::HTTP::Patch.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['X-N8N-API-KEY'] = N8N_API_KEY
  req['Accept']        = 'application/json'
  if body
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate(body)
  end
  use_ssl = uri.scheme == 'https'
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
