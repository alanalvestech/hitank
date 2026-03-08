# X (formerly Twitter) API v2 — OAuth 1.0a Authentication (HMAC-SHA1)
# Usage: require this file at the beginning of any skill script.
# Provides: x_request(method, path, body:, params:) helper

require 'json'
require 'net/http'
require 'uri'
require 'openssl'
require 'base64'
require 'securerandom'

CONFIG_DIR          = File.expand_path('~/.config/x')
API_KEY_FILE        = File.join(CONFIG_DIR, 'api_key')
API_SECRET_FILE     = File.join(CONFIG_DIR, 'api_secret')
ACCESS_TOKEN_FILE   = File.join(CONFIG_DIR, 'access_token')
ACCESS_SECRET_FILE  = File.join(CONFIG_DIR, 'access_token_secret')
BASE_URL            = 'https://api.twitter.com'

[API_KEY_FILE, API_SECRET_FILE, ACCESS_TOKEN_FILE, ACCESS_SECRET_FILE].each do |f|
  unless File.exist?(f)
    abort <<~MSG
      X credentials not found at #{f}
      Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
    MSG
  end
end

API_KEY        = File.read(API_KEY_FILE).strip
API_SECRET     = File.read(API_SECRET_FILE).strip
ACCESS_TOKEN   = File.read(ACCESS_TOKEN_FILE).strip
ACCESS_SECRET  = File.read(ACCESS_SECRET_FILE).strip

# Percent-encode per RFC 5849 (OAuth 1.0a)
def percent_encode(str)
  URI.encode_www_form_component(str.to_s).gsub('+', '%20')
end

# Build the OAuth 1.0a Authorization header
def oauth_header(method, url, params = {})
  oauth_params = {
    'oauth_consumer_key'     => API_KEY,
    'oauth_token'            => ACCESS_TOKEN,
    'oauth_signature_method' => 'HMAC-SHA1',
    'oauth_timestamp'        => Time.now.to_i.to_s,
    'oauth_nonce'            => SecureRandom.hex(16),
    'oauth_version'          => '1.0'
  }

  # Combine oauth params with any additional params (query params, form-encoded body params)
  all_params = oauth_params.merge(params)

  # Sort and encode all parameters for the signature base string
  param_string = all_params
    .sort_by { |k, _| k }
    .map { |k, v| "#{percent_encode(k)}=#{percent_encode(v)}" }
    .join('&')

  # Signature base string: METHOD&url&params
  base_string = [
    method.to_s.upcase,
    percent_encode(url),
    percent_encode(param_string)
  ].join('&')

  # Signing key: percent_encode(api_secret)&percent_encode(access_token_secret)
  signing_key = "#{percent_encode(API_SECRET)}&#{percent_encode(ACCESS_SECRET)}"

  # HMAC-SHA1 signature
  digest    = OpenSSL::Digest.new('sha1')
  signature = Base64.strict_encode64(OpenSSL::HMAC.digest(digest, signing_key, base_string))

  oauth_params['oauth_signature'] = signature

  # Build the Authorization header value
  header_parts = oauth_params
    .sort_by { |k, _| k }
    .map { |k, v| "#{percent_encode(k)}=\"#{percent_encode(v)}\"" }
    .join(', ')

  "OAuth #{header_parts}"
end

def x_request(method, path, body: nil, params: {})
  base_url = "#{BASE_URL}#{path}"
  uri = URI(base_url)

  # For GET requests, add params to the query string
  if method == :get && !params.empty?
    uri.query = URI.encode_www_form(params)
  end

  # Build the OAuth header
  # For GET: include query params in signature calculation
  # For POST/DELETE with JSON body: do NOT include body in signature (only form-encoded bodies are included)
  sig_params = method == :get ? params : {}
  auth = oauth_header(method, base_url, sig_params)

  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        end

  req['Authorization'] = auth
  req['User-Agent']    = 'hitank-x-skill/1.0'

  if body
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate(body)
  end

  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }

  unless resp.is_a?(Net::HTTPSuccess)
    abort "X API error #{resp.code}: #{resp.body}"
  end

  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
