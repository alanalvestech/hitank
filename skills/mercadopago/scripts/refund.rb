# Refund a payment
# Usage: ruby scripts/refund.rb PAYMENT_ID

require_relative 'auth'

payment_id = ARGV[0] or abort("Usage: ruby #{__FILE__} PAYMENT_ID")

data = mp_request(:post, "/v1/payments/#{payment_id}/refunds")

if data['error']
  abort "Error: #{data['message']} (#{data['error']})"
end

puts "refund_id:\t#{data['id']}"
puts "payment_id:\t#{data['payment_id']}"
puts "amount:\t#{data['amount']}"
puts "status:\t#{data['status']}"
puts "date_created:\t#{data['date_created'] || '-'}"
