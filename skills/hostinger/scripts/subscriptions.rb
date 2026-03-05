# List subscriptions
# Usage: ruby scripts/subscriptions.rb

require_relative 'auth'

data = hostinger_request(:get, '/api/billing/v1/subscriptions')

(data || []).each do |s|
  name    = s['name'] || '-'
  status  = s['status'] || '-'
  expires = s['expires_at'] || '-'
  puts "#{s['id']}\t#{name}\t#{status}\t#{expires}"
end
