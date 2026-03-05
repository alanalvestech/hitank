# List domains
# Usage: ruby scripts/domains.rb

require_relative 'auth'

data = resend_request(:get, '/domains')

(data['data'] || []).each do |d|
  puts "#{d['id']}\t#{d['name'] || '-'}\t#{d['status'] || '-'}\t#{d['region'] || '-'}"
end
