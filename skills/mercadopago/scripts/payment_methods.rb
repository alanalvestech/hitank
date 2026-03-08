# List available payment methods
# Usage: ruby scripts/payment_methods.rb

require_relative 'auth'

data = mp_request(:get, '/v1/payment_methods')

if data.nil? || data.empty?
  puts "No payment methods found"
  exit 0
end

data.each do |m|
  id     = m['id'] || '-'
  name   = m['name'] || '-'
  type   = m['payment_type_id'] || '-'
  status = m['status'] || '-'
  puts "#{id}\t#{name}\t#{type}\t#{status}"
end
