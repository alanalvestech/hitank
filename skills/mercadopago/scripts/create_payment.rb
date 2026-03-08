# Create a new payment
# Usage: ruby scripts/create_payment.rb 'JSON_BODY'
# Example: ruby scripts/create_payment.rb '{"transaction_amount":100.0,"description":"Product","payment_method_id":"pix","payer":{"email":"buyer@example.com"}}'

require_relative 'auth'

json_body = ARGV[0] or abort("Usage: ruby #{__FILE__} 'JSON_BODY'")

body = JSON.parse(json_body)

data = mp_request(:post, '/v1/payments', body: body)

if data['error']
  abort "Error: #{data['message']} (#{data['error']})"
end

puts "id:\t#{data['id']}"
puts "status:\t#{data['status']}"
puts "status_detail:\t#{data['status_detail']}"
puts "transaction_amount:\t#{data['transaction_amount']}"
puts "currency_id:\t#{data['currency_id']}"
puts "description:\t#{data['description'] || '-'}"
puts "payment_method_id:\t#{data['payment_method_id'] || '-'}"
puts "date_created:\t#{data['date_created'] || '-'}"
