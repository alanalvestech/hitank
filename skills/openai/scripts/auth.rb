# OpenAI API — Auth via Bearer Token
# Usage: require this file at the beginning of any skill script.
# Provides: openai_request(method, path, body:, headers:) helper

require 'json'
require 'net/http'
require 'uri'

TOKEN_FILE = File.expand_path('~/.config/openai/token')
BASE_URL   = 'https://api.openai.com/v1'

unless File.exist?(TOKEN_FILE)
  abort <<~MSG
    OpenAI token not found at #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

OPENAI_TOKEN = File.read(TOKEN_FILE).strip

def openai_request(method, path, body: nil, headers: {})
  uri = URI("#{BASE_URL}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['Authorization'] = "Bearer #{OPENAI_TOKEN}"
  headers.each { |k, v| req[k] = v }
  if body
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
