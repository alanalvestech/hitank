# Firebase / Google Cloud API — Auth via Service Account JWT + OAuth2
# Usage: require this file at the beginning of any skill script.
# Provides: firebase_request(method, path, body:, base_url:) helper

require 'json'
require 'net/http'
require 'uri'
require 'openssl'
require 'base64'
require 'fileutils'

CONFIG_DIR          = File.expand_path('~/.config/firebase')
SERVICE_ACCOUNT_FILE = File.join(CONFIG_DIR, 'service_account.json')
ACCESS_TOKEN_FILE    = File.join(CONFIG_DIR, 'access_token')
SCOPES              = 'https://www.googleapis.com/auth/cloud-platform https://www.googleapis.com/auth/firebase'

unless File.exist?(SERVICE_ACCOUNT_FILE)
  abort <<~MSG
    Service account key not found at #{SERVICE_ACCOUNT_FILE}
    Run: ruby #{File.expand_path('../check_setup.rb', __FILE__)}
  MSG
end

SERVICE_ACCOUNT = JSON.parse(File.read(SERVICE_ACCOUNT_FILE))

def base64url(data)
  Base64.urlsafe_encode64(data, padding: false)
end

def build_jwt
  now = Time.now.to_i
  header = { alg: 'RS256', typ: 'JWT' }
  claims = {
    iss:   SERVICE_ACCOUNT['client_email'],
    scope: SCOPES,
    aud:   SERVICE_ACCOUNT['token_uri'] || 'https://oauth2.googleapis.com/token',
    iat:   now,
    exp:   now + 3600
  }

  segments = [base64url(JSON.generate(header)), base64url(JSON.generate(claims))]
  signing_input = segments.join('.')

  key = OpenSSL::PKey::RSA.new(SERVICE_ACCOUNT['private_key'])
  signature = key.sign(OpenSSL::Digest::SHA256.new, signing_input)

  "#{signing_input}.#{base64url(signature)}"
end

def fetch_access_token
  # Check cached token
  if File.exist?(ACCESS_TOKEN_FILE)
    cached = JSON.parse(File.read(ACCESS_TOKEN_FILE))
    if cached['expires_at'].to_i > Time.now.to_i + 60
      return cached['access_token']
    end
  end

  # Exchange JWT for access token
  jwt = build_jwt
  token_uri = URI(SERVICE_ACCOUNT['token_uri'] || 'https://oauth2.googleapis.com/token')

  req = Net::HTTP::Post.new(token_uri)
  req['Content-Type'] = 'application/x-www-form-urlencoded'
  req.body = URI.encode_www_form(
    grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    assertion:  jwt
  )

  resp = Net::HTTP.start(token_uri.host, token_uri.port, use_ssl: true) { |h| h.request(req) }

  unless resp.is_a?(Net::HTTPSuccess)
    abort "Failed to obtain access token: #{resp.code} #{resp.body}"
  end

  data = JSON.parse(resp.body)
  token = data['access_token']
  expires_in = data['expires_in'] || 3600

  # Cache token
  FileUtils.mkdir_p(CONFIG_DIR)
  File.write(ACCESS_TOKEN_FILE, JSON.generate(
    access_token: token,
    expires_at:   Time.now.to_i + expires_in.to_i
  ))
  File.chmod(0600, ACCESS_TOKEN_FILE)

  token
end

FIREBASE_TOKEN = fetch_access_token

def firebase_request(method, path, body: nil, base_url: 'https://firebase.googleapis.com')
  uri = URI("#{base_url}#{path}")
  req = case method
        when :get    then Net::HTTP::Get.new(uri)
        when :put    then Net::HTTP::Put.new(uri)
        when :post   then Net::HTTP::Post.new(uri)
        when :patch  then Net::HTTP::Patch.new(uri)
        when :delete then Net::HTTP::Delete.new(uri)
        end
  req['Authorization'] = "Bearer #{FIREBASE_TOKEN}"
  req['Content-Type']  = 'application/json' if body
  req.body = JSON.generate(body) if body

  resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  return nil if resp.body.nil? || resp.body.empty?
  JSON.parse(resp.body)
end
