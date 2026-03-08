# MercadoPago API — Auth via Bearer Token
# Usage: require this file at the beginning of any skill script.
# Provides: mp_request(method, path, body:) helper

require 'json'
require 'net/http'
require 'uri'

TOKEN_FILE = File.expand_path('~/.config/mercadopago/token')
BASE_URL   = 'https://api.mercadopago.com'

unless File.exist?(TOKEN_FILE)
  abort <<~MSG
    MercadoPago token not found at #{TOKEN_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

MP_TOKEN = File.read(TOKEN_FILE).strip

def mp_request(method, path, body: nil)
  uri = URI("#{BASE_URL}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :patch  then Net::HTTP::Patch.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['Authorization'] = "Bearer #{MP_TOKEN}"
  req['Content-Type']  = 'application/json'
  if body
    req.body = JSON.generate(body)
  end
  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
