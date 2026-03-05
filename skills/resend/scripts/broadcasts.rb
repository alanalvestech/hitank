# List broadcasts
# Usage: ruby scripts/broadcasts.rb

require_relative 'auth'

data = resend_request(:get, '/broadcasts')

(data['data'] || []).each do |b|
  puts "#{b['id']}\t#{b['name'] || '-'}\t#{b['subject'] || '-'}\t#{b['status'] || '-'}\t#{b['created_at'] || '-'}"
end
